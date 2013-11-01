Installing on Mac OSX

Better if remote login is checked only for hadoop account
(System Preferences -> System -> Accounts add account)

If Homebrew is installed:
brew install hadoop

Note that older versions of brew might try to install older versions of hadoop (e.g. 1.0)
and return 404 download error if tar file for the version is no longer available

rm -rf /usr/local/.git && brew cleanup
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
brew install hadoop

/usr/local/Cellar/hadoop/1.2.1/libexec/conf/hadoop-env.sh

<configuration>
<property>
    <name>fs.default.name</name>
    <value>hdfs://localhost:9000</value>
</property>
</configuration>

/usr/local/Cellar/hadoop/1.2.1/libexec/conf/hdfs-site.xml
<configuration>
<property>
    <name>dfs.replication</name>
    <value>1</value>
</property>
</configuration>

/usr/local/Cellar/hadoop/1.2.1/libexec/conf/mapred-site.xml
<configuration>
<property>
    <name>mapred.job.tracker</name>
    <value>localhost:9001</value>
</property>
</configuration>

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

bin/hadoop namenode -format

start:
bin/start-all.sh