Apache Pig scripts can be executed in three ways: interactive mode, batch mode, and embedded mode

Local mode	

$ ./pig –x local

MAp reduce mode

$ ./pig -x mapreduce

After invoking the Grunt shell, you can execute a Pig script by directly entering the Pig Latin statements in it:

grunt> customers = LOAD 'customers.txt' USING PigStorage(',');
