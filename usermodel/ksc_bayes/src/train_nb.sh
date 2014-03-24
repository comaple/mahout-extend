#!/bin/bash
##############################################################
### Author : comaple.zhnag
### Create Time : 20140306
### Usage : to train the model from the give data 
###			whitch extract from hive table kp_userpreference
#############################################################


RATE=$1
shift

if [ "x"$1 = "x" ]
then
        date_1=`/data/dw/script/utils/dateprocess.pl dateadd -8 yyyymm/dd`
        date_2=`/data/dw/script/utils/dateprocess.pl dateadd -8 yyyy/mm/dd`
        date_3=`/data/dw/script/utils/dateprocess.pl dateadd -8 yyyy-mm-dd`
        date_4=`/data/dw/script/utils/dateprocess.pl dateadd -8 yyyymmdd`
	shift
else
        date_1=`/data/dw/script/utils/dateprocess.pl format yyyymm/dd $1`
        date_2=`/data/dw/script/utils/dateprocess.pl format yyyy/mm/dd $1`
        date_3=`/data/dw/script/utils/dateprocess.pl format yyyy-mm-dd $1`
        date_4=`/data/dw/script/utils/dateprocess.pl format yyyymmdd $1`
	shift
fi

DATE=$date_4
BASE_APP_DIR=$(dirname $(pwd))

sh process_value.sh $DATE

echo use $PATE ,to split data ...
python split.py  -i $BASE_APP_DIR/model/data_processed.txt -p $BASE_APP_DIR/model/data -r $RATE

echo training ....

python nb.py 1 $BASE_APP_DIR/model/data_train $BASE_APP_DIR/model/data_model

echo testing ....

python nb.py 0 $BASE_APP_DIR/model/data_test $BASE_APP_DIR/model/data_model $BASE_APP_DIR/model/data_out

echo success ....
