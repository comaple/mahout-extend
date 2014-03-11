DROP TABLE IF EXISTS ksckd.kp_prefrst;
CREATE EXTERNAL TABLE ksckd.kp_prefrst
(
uid bigint,
wfile_count bigint,
login_fr int,
upload_real bigint,
user_ret  bigint ,
account_info bigint,
download bigint,
upload bigint,
filemanage bigint,
classfier string
)
PARTITIONED BY(day int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" STORED AS RCFILE  LOCATION '/user/hive/warehouse/ksckd/kp_prefrst'
