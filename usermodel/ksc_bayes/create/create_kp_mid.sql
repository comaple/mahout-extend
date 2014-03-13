DROP TABLE IF EXISTS ksckd.kp_mid;
CREATE EXTERNAL TABLE ksckd.kp_mid
(
uid bigint,
wfile_count bigint,
login_fr int,
user_ret  bigint ,
download bigint,
filemanage bigint,
terminal string,
registtype string,
score float
)
PARTITIONED BY(day int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" STORED AS TEXTFILE  LOCATION '/user/hive/warehouse/ksckd/kp_mid'
