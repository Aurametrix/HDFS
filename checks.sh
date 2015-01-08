!/bin/bash

clear				# clear terminal window

echo "The script starts now."

echo "Hi, $USER!"		# get content of variable
echo

# disk usage to estimate space used on a file system
du -sh
# % of used space on Hadoop cluster
sudo -u hdfs hadoop fs –df
hdfs dfs -du [-s] [-h] URI [URI …]
hdfs dfs -dus <args>

# Capacity under specific folder
sudo -u hdfs hadoop fs -du -h /user
