DROP TABLE IF EXISTS ksckd.kp_usermodel;
CREATE EXTERNAL TABLE ksckd.kp_usermodel
(
wfile_count bigint,
login_fr bigint,
user_ret bigint,
download bigint,
uid bigint,
is_user int
)
PARTITIONED BY(day int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" STORED AS TEXTFILE  LOCATION '/user/hive/warehouse/ksckd/kp_usermodel'
