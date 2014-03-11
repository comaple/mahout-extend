#!/bin/bash
########################################################################
### authoe : comaple.zhang
### create time : 20140213
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

date_before_31=`/data/dw/script/utils/dateprocess.pl dateadd -30 yyyymmdd $date_4`
date_before_1=`/data/dw/script/utils/dateprocess.pl dateadd -0 yyyymmdd $date_4`
date_before_2=`/data/dw/script/utils/dateprocess.pl dateadd -1 yyyymmdd $date_4`
date_before_3=`/data/dw/script/utils/dateprocess.pl dateadd -2 yyyymmdd $date_4`
date_before_4=`/data/dw/script/utils/dateprocess.pl dateadd -3 yyyymmdd $date_4`

date_before_8=`/data/dw/script/utils/dateprocess.pl dateadd -7 yyyymmdd $date_4`
date_before_15=`/data/dw/script/utils/dateprocess.pl dateadd -14 yyyymmdd $date_4`
date_before_29=`/data/dw/script/utils/dateprocess.pl dateadd -28 yyyymmdd $date_4`




#begin_date=`/data/dw/script/utils/dateprocess.pl dateadd $i yyyymmdd $1`
begin_date=${date_4}
begin_1_date=`/data/dw/script/utils/dateprocess.pl dateadd 1 yyyymmdd $begin_date`
last_date=`/data/dw/script/utils/dateprocess.pl dateadd 7 yyyymmdd $begin_date`
begin_5_date=`/data/dw/script/utils/dateprocess.pl dateadd 5 yyyymmdd $begin_date`
last_4_date=`/data/dw/script/utils/dateprocess.pl dateadd 4 yyyymmdd $begin_date`
echo date_4 : $date_4
echo begin_date : $begin_date
echo last_date : $last_date

########  计算wfile count
sql="DROP TABLE IF EXISTS ksckd.tmp_wfile ;CREATE TABLE ksckd.tmp_wfile AS 
SELECT '$begin_date',a.uid uid, IF(b.cnt IS NOT NULL,b.cnt,0)  wfile_count,a.terminal terminal,a.channel channel FROM
(SELECT uid,terminal,channel FROM kp_regist WHERE day='$begin_date')a
LEFT OUTER JOIN
(SELECT uid,COUNT(1) cnt FROM 
kp_pv 
WHERE fun = 'commitKss' and status = '200 ok' and day BETWEEN '$begin_date' AND '$last_date'
GROUP BY uid)b ON a.uid=b.uid"

echo "$sql"

hive -e "$sql"
sql="DROP TABLE IF EXISTS ksckd.tmp_loginfr ;CREATE TABLE ksckd.tmp_loginfr AS
SELECT '$begin_date', a.uid uid,IF(b.day_c IS NOT NULL,b.day_c,0) day_c ,a.terminal terminal FROM
(SELECT uid,terminal FROM kp_regist WHERE day='$begin_date' GROUP BY uid ,terminal)a
LEFT OUTER JOIN
(
SELECT uid ,COUNT(DISTINCT substring(ctime_id,0,8)) day_c FROM kp_loginhistory
WHERE substring(ctime_id,0,8)  BETWEEN '$begin_1_date' AND '$last_4_date' GROUP BY uid
)b ON a.uid=b.uid"

echo "$sql"
hive -e "$sql"
sql="DROP TABLE IF EXISTS ksckd.tmp_ret;CREATE TABLE ksckd.tmp_ret AS
SELECT '$begin_date' ,a.uid uid,IF(b.uid IS NOT NULL,1,0) is_keep,a.terminal terminal FROM
(SELECT uid ,terminal FROM kp_regist WHERE day = '$begin_date' )a
LEFT OUTER JOIN
(SELECT uid FROM kp_day_uid WHERE day BETWEEN '$begin_5_date' AND '$last_date')b
ON a.uid=b.uid"

echo "$sql"
hive -e "$sql"
###### SUM(CAST( get_json_object(get_json_object(params,'$.block_infos'),'$.block_infos\[0].size') AS FLOAT)) 
sql="DROP TABLE IF EXISTS ksckd.tmp_keyfun ;CREATE TABLE ksckd.tmp_keyfun AS
SELECT '$begin_date', a.uid,
	      SUM(IF(b.fun in('requestDownloadKss','requestDownloadXL'),b.cnt,0)) download,
	      SUM(IF(b.fun in('syncFile','metadata'),b.cnt,0)) filemanage,
	      a.terminal terminal,
	      a.channel channel
 FROM
(SELECT uid ,terminal,channel FROM kp_regist WHERE day='$begin_date')a
LEFT OUTER JOIN
(SELECT uid,COUNT(1) cnt,fun FROM 
kp_pv 
WHERE fun in ('requestDownloadKss','requestDownloadXL','syncFile','metadata')
and day BETWEEN '$begin_1_date' AND '$last_date' GROUP BY uid ,fun
)b ON a.uid=b.uid GROUP BY a.uid ,a.terminal,a.channel"

echo ----------------- "$sql" ------------------
hive -e "$sql"

sql="INSERT OVERWRITE TABLE ksckd.kp_userpreference PARTITION (day=$begin_date)
SELECT a.uid ,MAX(a.wfile_count),MAX(b.day_c),0,MAX(d.is_keep), MAX(e.account_info),MAX(e.download),MAX(e.upload),MAX(e.filemanage), a.terminal,a.channel  FROM
(SELECT uid,wfile_count,terminal,channel FROM ksckd.tmp_wfile GROUP BY uid,wfile_count,terminal,channel) a
JOIN
(SELECT uid,day_c,terminal FROM ksckd.tmp_loginfr GROUP BY uid,day_c,terminal )b ON (a.uid=b.uid and a.terminal=b.terminal)
JOIN
(SELECT uid,is_keep,terminal FROM ksckd.tmp_ret GROUP BY uid, is_keep ,terminal) d ON (a.uid=d.uid and a.terminal=d.terminal) 
JOIN
(SELECT uid ,0 account_info,0 upload,download,filemanage,terminal FROM ksckd.tmp_keyfun GROUP BY uid,filemanage,terminal,download) e ON (a.uid=e.uid and a.terminal=e.terminal) GROUP BY a.uid ,a.terminal,a.channel"

echo "$sql"

hive -e "$sql"


