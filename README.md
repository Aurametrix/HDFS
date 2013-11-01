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

Fixing newline errors
cat /usr/local/Cellar/hadoop/1.2.1/libexec/bin/../conf/hadoop-env.sh | sed '/\015/d' >h2.sh

to edit in the editor: 
Press command + shift + G & type /usr/local/.. in the popped-up dialog

Job tracker:
http://localhost:50030/jobtracker.jsp

HBase
Use Apache HBase when you need random, realtime read/write access to your Big Data: 
billions of rows X millions of columns -- atop clusters of commodity hardware.

brew install hbase
for version 0.94.11
edit /usr/local/Cellar/hbase/0.94.11/libexec/conf/hbase-env.sh

export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

export HBASE_CLASSPATH=/usr/local/Cellar/hadoop/0.94.11/libexec/conf


/usr/local/Cellar/hbase/0.94.11/libexec/conf/hbase-site.xml
/usr/local/Cellar/hbase/0.94.11/libexec/conf/hbase-env.xml

<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
<name>hbase.rootdir</name>
<value>hdfs://localhost:9000/hbase</value>
<description>The directory shared by region servers.
</description>
</property>
<property>
<name>hbase.zookeeper.property.dataDir</name>
<value>file:///usr/local/Cellar/hbase/0.94.0/hbase-nicole.hu/zookeeper</value>
</property>
</configuration>

Note that pasting it in the wrong place (adding extra xml version) will lead to 
“[xX][mM][lL]” is not allowed.” error. Make sure there are no blank spaces on top


~/.bash_profile

export HADOOP_HOME=/usr/local/Cellar/hadoop/1.2.1

export HBASE_HOME=/usr/local/Cellar/hbase/0.94.11/libexec

Start HBase
/usr/local/Cellar/hbase/0.94.11/bin/start-hbase.sh

hbase shell

test:
create "testtable", "testcolumn"

possible errors:
ERROR zookeeper.RecoverableZooKeeper: ZooKeeper exists failed after 3 retries

if missing hbase.zookeeper.quorum in configuration
A distributed Apache HBase installation depends on a running ZooKeeper cluster.