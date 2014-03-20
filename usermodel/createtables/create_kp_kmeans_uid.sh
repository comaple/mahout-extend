DROP TABLE IF EXISTS ksckd.kp_kmeans_uid;
CREATE EXTERNAL TABLE ksckd.kp_kmeans_uid
(
classid bigint,
uid bigint,
cnt_00_05 int,
cnt_07_12 int,
cnt_12_14 int,
cnt_14_17 int,
cnt_17_21 int,
cnt_21_23 int
)
PARTITIONED BY(day int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" STORED AS TEXTFILE  LOCATION '/user/hive/warehouse/ksckd/kp_kmeans_uid'
