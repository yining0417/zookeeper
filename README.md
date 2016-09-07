# zookeeper

First, modify the code in Leader.java and LearnerHandler.java  Add some timestamp to it. 

Then run the command in the zookeeper folder, it will produce a zookeeper-3.4.6.tar.gz in the build folder.
> ant -Djavac.args="-Xlint -Xmaxwarns 1000" clean tar

Tar the zookeeper-3.4.6.tar.gz and mv zookeeper-3.4.6 zookeeper. Or you could copy the zookeeper.jar to a existing zookeeper folder.

The zkEval.sh in zookeeper folder could run and get result.
./zkEval 3 10 means 3 zookeeper servers and 10 clients.

And Finally you will get a consensus.txt in leader's /home/* folder, the second data means consensus latency while the third means get first ack. The fourth means the number of majority ack.

