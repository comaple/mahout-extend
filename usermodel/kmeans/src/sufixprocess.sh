#!/bin/bash
#######################################################################
### Author : comaple.zhang
### Create Time : 20140320
### Usage : to run the kmeans sufix process.
#######################################################################


if [ $# -ne 1 ]
then
ehco please input the a day for argument.
exit
fi

dt=$1

#sudo cp /home/zhangshengtao/ReadKmeans.jar ./

hadoop  jar ReadKmeans.jar -i /user/ksckd/usermodel/kmeans/output -k 7 -o /user/hive/warehouse/ksckd/kp_kmeans_uid/day=$dt --output_rest /user/hive/warehouse/ksckd/kp_kmeans_class/day=$dt

hadoop fs -ls /user/hive/warehouse/ksckd/kp_kmeans_uid/day=$dt/

rm -rf part-m-00000

hadoop fs -get /user/hive/warehouse/ksckd/kp_kmeans_uid/day=$dt/part-m-00000 ./

rm -rf part-result-k

hadoop fs -get /user/hive/warehouse/ksckd/kp_kmeans_class/day=$dt/part-m-00000 ./part-result-k

hive -e "use ksckd;alter table kp_kmeans_uid add partition (day=$dt)"

hive -e "use ksckd;alter table kp_kmeans_class add partition (day=$dt)"

