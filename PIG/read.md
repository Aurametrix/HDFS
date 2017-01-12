 https://pig.apache.org/
 
 $ mkdir Pig

$ cd Downloads/ 

$ tar zxvf pig-0.15.0-src.tar.gz 

$ tar zxvf pig-0.15.0.tar.gz 

$ mv pig-0.15.0-src.tar.gz/* /home/Hadoop/Pig/


.bashrc file

Change PIG_HOME folder to the Apache Pig’s installation folder,

Set PATH environment variable to the bin folder, and

PIG_CLASSPATH environment variable to the etc (configuration) folder of your Hadoop installations (the directory that contains the core-site.xml, hdfs-site.xml and mapred-site.xml files).

export PIG_HOME = /home/Hadoop/Pig
export PATH  = PATH:/home/Hadoop/pig/bin
export PIG_CLASSPATH = $HADOOP_HOME/conf
pig.properties file


In the conf folder of Pig, we have a file named pig.properties. In the pig.properties file, you can set various parameters as given below.

pig -h properties 

======================================
Apache Pig scripts can be executed in three ways: interactive mode, batch mode, and embedded mode

Local mode	

$ ./pig –x local

Map reduce mode

$ ./pig -x mapreduce

After invoking the Grunt shell, you can execute a Pig script by directly entering the Pig Latin statements in it:

grunt> customers = LOAD 'customers.txt' USING PigStorage(',');
