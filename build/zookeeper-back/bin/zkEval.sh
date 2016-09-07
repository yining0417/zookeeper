#!/bin/bash

#This script is evaluation of zookeeeper, the first parameter $1 is the count of zookeeper
#The second parameter $2 is the count of worker 
set -x

zoo_path=/home/ning/zookeeper/build/zookeeper
zoo_exe=$zoo_path/bin
zk_smoke=/home/ning/zk-smoketest
consensus_file=/home/ning/consensus.txt

current=1
while [ $current -lt 10 ]
do
    line="10.22.1.${current}"
    ssh $LOGNAME@${line} "sudo $zoo_exe/zkServer.sh stop"
    ssh $LOGNAME@${line} "sudo rm $consensus_file"
    scp $zoo_path/zookeeper-3.4.6.jar $LOGNAME@${line}:$zoo_path
    scp $zoo_path/conf/zoo.cfg $LOGNAME@${line}:$zoo_path/conf
    current=`expr $current + 1`
done

sleep 5

current=1

while [ $current -lt `expr $1 + 1` ]
do
	ip="10.22.1.${current}"
	ssh ${ip} "sudo $zoo_exe/zkServer.sh start"
	current=`expr $current + 1`
done

sleep 10

for(( i = 0; i < $2; i++ ))  
do  
{  
	cd $zk_smoke; ./run.sh $i
}&  
done  
wait  
  
sleep 10


current=1
while [ $current -lt 10 ]
do
	ip="10.22.1.${current}"
    	line=`ssh $LOGNAME@${ip} "cat $consensus_file | wc -l"`
	if [ $line -gt 1000 ]; then
		echo ${ip}
		ssh $LOGNAME@${ip} "awk '{ sum += \$1; n++ } END { if (n > 0) print sum / n; }' $consensus_file"
		break
	fi
	current=`expr $current + 1`
done


