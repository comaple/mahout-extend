#!/bin/bash
##############################################################
### Author : comaple.zhnag
### Create Time : 20140306
### Usage : to train the model from the give data 
###			whitch extract from hive table kp_userpreference
#############################################################

RATE=$1

DATE=20140225
BASE_APP_DIR=$(dirname $(pwd))

sh process_value.sh $DATE

echo use $PATE ,to split data ...
python split.py  -i $BASE_APP_DIR/model/data_processed.txt -p $BASE_APP_DIR/model/data -r $RATE

echo training ....

python nb.py 1 $BASE_APP_DIR/model/data_train $BASE_APP_DIR/model/data_model

echo testing ....

python nb.py 0 $BASE_APP_DIR/model/data_test $BASE_APP_DIR/model/data_model $BASE_APP_DIR/model/data_out

echo success ....
