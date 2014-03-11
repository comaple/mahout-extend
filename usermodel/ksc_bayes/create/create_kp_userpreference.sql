DROP TABLE IF EXISTS ksckd.kp_userpreference;
CREATE EXTERNAL TABLE ksckd.kp_userpreference
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
terminal string,
channel string,
registtype string
)
PARTITIONED BY(day int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" STORED AS RCFILE  LOCATION '/user/hive/warehouse/ksckd/kp_userpreference'
