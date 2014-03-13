
path=$1
tablename=$2
dt=$3

hive -e "LOAD DATA LOCAL INPATH '$path' OVERWRITE INTO TABLE $tablename PARTITION (day=$dt)"
