#!/bin/sh

#获得当前shell所在路径
basepath=$(cd `dirname $0`; pwd)
#echo $basepath

#jvm启动参数
#GC_OPTS="-XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCApplicationStoppedTime -Xloggc:/data/dbus-canal-auto/logs/gc/gc.log"
LOG_CONF="-Dlogs.base.path=$basepath -Duser.dir=$basepath"
OOM_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$basepath/logs/oom"
JVM_OPTS="-server -Xmx4096m -Xms4096m -XX:NewRatio=1"
CLASS_PATH=""
MAIN=" com.creditease.dbus.canal.auto.deploy.AutoDeployStart"
if [ "x$1" = "xcheck" ]
then
        MAIN="com.creditease.dbus.canal.auto.check.AutoCheckStart"
fi


#导入jar和config进入classpath
for i in $basepath/lib/*.jar;
        do CLASS_PATH=$i:"$CLASS_PATH";
done
export CLASS_PATH=.:$CLASS_PATH

echo "******************************************************************************"
echo "*CLASS_PATH: " $CLASS_PATH
echo "*   GC_OPTS: " $GC_OPTS
echo "*  OOM_OPTS: " $OOM_OPTS
echo "*  JVM_OPTS: " $JVM_OPTS
echo "*      MAIN: " $MAIN
echo "*         1: " $1
echo "******************************************************************************"

java $JVM_OPTS $LOG_CONF $OOM_OPTS -classpath $CLASS_PATH $MAIN

canal_path="$basepath/canal"

pid=`ps aux | grep "$canal_path/bin" | grep -v "grep" | awk '{print $2}'`
if [ "x$pid" != "x" ]; then
         echo "canal pid start success ,pid is $pid "
         sleep 1
fi
