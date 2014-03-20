#!/bin/bash
########################################################################
### Author : comaple.zhang
### Create Time : 20140306
###	Usage : run user model
###	Coment : sh regular_test.sh 20140210
########################################################################

if [ "x"$1 = "x" ]
then
        date_1=`/data/dw/script/utils/dateprocess.pl dateadd -9 yyyymm/dd`
	    date_2=`/data/dw/script/utils/dateprocess.pl dateadd -9 yyyy/mm/dd`
	    date_3=`/data/dw/script/utils/dateprocess.pl dateadd -9 yyyy-mm-dd`
	    date_4=`/data/dw/script/utils/dateprocess.pl dateadd -9 yyyymmdd`
else
	    date_1=`/data/dw/script/utils/dateprocess.pl format yyyymm/dd $1`
	    date_2=`/data/dw/script/utils/dateprocess.pl format yyyy/mm/dd $1`
		date_3=`/data/dw/script/utils/dateprocess.pl format yyyy-mm-dd $1`
		date_4=`/data/dw/script/utils/dateprocess.pl format yyyymmdd $1`
fi
#BASE_APP_PATH=$(dirname $(pwd))
BASE_APP_PATH=/data/ksckd/usermodel/ksc_bayes
HIVE_LIB=/usr/local/hive/bin

START_TIME=$(date +%s)

### extract data to hive table kp_userpreference
echo begin to extract data to hive table ...
sh $BASE_APP_PATH/src/user_preference.sh $date_4

### extract data from hive table kp_userpreference ,and preprocess the data for the usermodel's input
echo begin to extract data from hive table to local file ...

sh $BASE_APP_PATH/src/process_value.sh $date_4

### get the test data from the last step 
echo begin to split data to test data set ...
python $BASE_APP_PATH/src/split.py -i $BASE_APP_PATH/model/data_processed.txt  -p $BASE_APP_PATH/model/data -r 0.0

### run model testing everyday
echo begin to test data ... 
python $BASE_APP_PATH/src/nb.py 2 $BASE_APP_PATH/model/data_test $BASE_APP_PATH/model/data_model $BASE_APP_PATH/model/data_result.txt

cat $BASE_APP_PATH/model/data_result.txt | cut -f2,3,4,5,6,7,8 > $BASE_APP_PATH/model/data_hive_table.txt
### load data into hive table

$HIVE_LIB/hive -e "load data local inpath '$BASE_APP_PATH/model/data_hive_table.txt' overwrite into table ksckd.kp_usermodel partition (day=$date_4)"

END_TIME=$(date +%s)

length=$(echo "$END_TIME - $START_TIME"| bc)

echo "The caculate time elipsed : $length"
