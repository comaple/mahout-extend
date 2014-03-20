#!/bin/bash
########################################################################
### authoe : comaple.zhang
### create time : 20140314
### comment : use to caculate the channel's trake
#########################################################################

if [ "x"$1 = "x" ]
then
        date_1=`/data/dw/script/utils/dateprocess.pl dateadd -1 yyyymm/dd`
        date_2=`/data/dw/script/utils/dateprocess.pl dateadd -1 yyyy/mm/dd`
        date_3=`/data/dw/script/utils/dateprocess.pl dateadd -1 yyyy-mm-dd`
        date_4=`/data/dw/script/utils/dateprocess.pl dateadd -1 yyyymmdd`
else
        date_1=`/data/dw/script/utils/dateprocess.pl format yyyymm/dd $1`
        date_2=`/data/dw/script/utils/dateprocess.pl format yyyy/mm/dd $1`
        date_3=`/data/dw/script/utils/dateprocess.pl format yyyy-mm-dd $1`
        date_4=`/data/dw/script/utils/dateprocess.pl format yyyymmdd $1`
fi

## extract message from kp_pv for kmeans

sql="SELECT 	uid,
		COUNT(IF(time_id between ${date_4}00 and ${date_4}07,uid,null)) cnt_00_05,
		COUNT(IF(time_id between ${date_4}07 and ${date_4}12,uid,null)) cnt_07_12,
		COUNT(IF(time_id between ${date_4}12 and ${date_4}14,uid,null)) cnt_12_14,
		COUNT(IF(time_id between ${date_4}14 and ${date_4}17,uid,null)) cnt_14_17,
		COUNT(IF(time_id between ${date_4}17 and ${date_4}21,uid,null)) cnt_17_21,
		COUNT(IF(time_id between ${date_4}21 and ${date_4}23,uid,null)) cnt_21_23
FROM kp_pv 
WHERE
day=${date_4} AND fun in ('commitKss','requestDownloadKss','requestDownloadXL')
GROUP BY uid"

echo "$sql"
hive -e "$sql" > user_active_${date_4}.txt

