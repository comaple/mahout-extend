DROP TABLE IF EXISTS ksckd.kp_kmeans_class;
CREATE EXTERNAL TABLE ksckd.kp_kmeans_class
(
classid bigint,
mun int,
center String,
radius string
)
PARTITIONED BY(day int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" STORED AS TEXTFILE  LOCATION '/user/hive/warehouse/ksckd/kp_kmeans_class'
