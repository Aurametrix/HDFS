/* extract all user IDs from the etc passwd  */
/* run this script in local or mapreduce mode */

A = load 'passwd' using PigStorage(':');  -- load the passwd file 
B = foreach A generate $0 as id;  -- extract the user IDs 
store B into ‘id.out’;  -- write the results to a file name id.out
