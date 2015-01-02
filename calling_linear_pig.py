#!/usr/bin/env python

import os
import sys
import shutil
import random
import tempfile
import Queue

from org.apache.pig.scripting import Pig 
from org.codehaus.jackson.map import ObjectMapper

EPS          = 10e-6      # maximum distance between consective weights for convergence

pig_script   = sys.argv[1] # pig script to run iteratively
data_dir     = sys.argv[2] # directory where intermediate weights will be written
features     = sys.argv[3] # location, inside data_dir, where the data to fit exists
num_features = sys.argv[4] # number of features

#
# Cleanup data dir
#
cmd = "rmr %s/weight-*" % data_dir    
Pig.fs(cmd)

#
# Initialize weights
#
w0_fields = []
weights   = []
for i in xrange(int(num_features)):
    weights.append(str(random.random()))    
    w0_fields.append({"name":"w%s" % i,"type":25,"schema":None}) # See Pig's DataType.java

path = tempfile.mkdtemp()
w0   = open("%s/part-r-00000" % path, 'w')
w0.write("\t".join(weights)+"\n")
w0.close()

#
# Create schema for weights, place under weight-0 dir
#
w0_schema      = {"fields":w0_fields,"version":0,"sortKeys":[],"sortKeyOrders":[]}
w0_schema_file = open("%s/.pig_schema" % path, 'w')
ObjectMapper().writeValue(w0_schema_file, w0_schema);
w0_schema_file.close()

#
# Copy initial weights to fs
#
copyFromLocal = "copyFromLocal %s %s/%s" % (path, data_dir, "weight-0")
Pig.fs(copyFromLocal)


#
# Iterate until converged
#
features     = "%s/%s" % (data_dir,features)
script       = Pig.compileFromFile(pig_script)
weight_queue = Queue.Queue(25) # for moving average
avg_weight   = [0.0 for i in xrange(int(num_features))]
converged    = False
prev         = 0
weight_dir   = tempfile.mkdtemp()

while not converged:
    input_weights  = "%s/weight-%s" % (data_dir,prev)
    output_weights = "%s/weight-%s" % (data_dir,prev+1)

    bound = script.bind({'input_weights':input_weights,'output_weights':output_weights,'data':features})
    bound.runSingle()
    
    
    #
    # Copy schema for weights to each output
    #
    copyOutputSchema = "cp %s/.pig_schema %s/.pig_schema" % (input_weights, output_weights)
    Pig.fs(copyOutputSchema)

    #
    # The first few iterations the weights bounce all over the place
    #
    if (prev > 1):
        copyToLocalPrev = "copyToLocal %s/part-r-00000 %s/weight-%s" % (input_weights, weight_dir, prev)
        copyToLocalNext = "copyToLocal %s/part-r-00000 %s/weight-%s" % (output_weights, weight_dir, prev+1)

        Pig.fs(copyToLocalPrev)
        Pig.fs(copyToLocalNext)

        localPrev = "%s/weight-%s" % (weight_dir, prev)
        localNext = "%s/weight-%s" % (weight_dir, prev+1)
        
        x1 = open(localPrev,'r').readlines()[0]
        x2 = open(localNext,'r').readlines()[0]

        x1 = [float(x.strip()) for x in x1.split("\t")]
        x2 = [float(x.strip()) for x in x2.split("\t")]

        weight_queue.put(x1)

        avg_weight = [x[1] + (x[0] - x[1])/(prev-1.0) for x in zip(x1,avg_weight)]
        
        #
        # Make sure to collect enough weights into the average before
        # checking for convergence
        #
        if (prev > 25):
            first_weight = weight_queue.get()
            avg_weight   = [(x[0] - x[1]/25.0 + x[2]/25.0) for x in zip(avg_weight, first_weight, x1)]
            
            #
            # Compute distance from weight centroid to new weight 
            #
            d = sum([(pair[0] - pair[1])**2 for pair in zip(x2,avg_weight)])
            
            converged = (d < EPS)
                    
        os.remove(localPrev)
        os.remove(localNext)
        

    prev += 1
     
#
# Cleanup
#
shutil.rmtree(path)
shutil.rmtree(weight_dir)
