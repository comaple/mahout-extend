#!/bin/base
##################################################
### Usage : process the value 
### Author : comaple.zhang
### Create Time : 20140221
####################################################

##### parse arguments
if [ $# -eq 1 ]
then
dt=$1
else
d=`/data/dw/script/utils/dateprocess.pl dateadd -8 yyyymmdd`
fi

BASE_DIR=$(dirname $(pwd))
VALUE_FILE_PATH=$BASE_DIR/input/kp_userpreference.txt
VALUE_FILE_SAMPLE=$BASE_DIR/input/kp_userpreference_sample_field.txt
VALUE_FILE_NUMERIC=$BASE_DIR/input/kp_userpreference_numeric.txt
VALUE_FILE_BUCKET=$BASE_DIR/input/kp_userpreference_bucket.txt
##########################################################
### export data to local disk
### 
##########################################################
sql="SELECT
uid,
wfile_count,
download,
filemanage,
terminal
FROM ksckd.kp_userpreference WHERE day=${dt} GROUP BY uid, wfile_count,download,filemanage,terminal"
echo "$sql"
#hive -e "$sql" > $VALUE_FILE_PATH
################################################################
### process data from hive 
### process data to fit the use for the model training 
###############################################################
## 截取需要的字段，进行处理
echo -e "\nsample data ....\n"
cat $VALUE_FILE_PATH |cut -f1,2,3,4 > $VALUE_FILE_SAMPLE
## 对数据进行归一化处理，并按照权重计算得出用户的有效性 
echo -e "numeric the data ....\n"
python caculate_train.py $VALUE_FILE_SAMPLE > $VALUE_FILE_NUMERIC
## 对各个字段进行分箱处理，得到离散数据，为贝叶斯算法做准备数据
echo -e "process the field ....\n"
python process_field.py $VALUE_FILE_NUMERIC 1 2 > $BASE_DIR/tmp/train_input_1.txt
python process_field.py $BASE_DIR/tmp/train_input_1.txt  2 10 > $BASE_DIR/tmp/train_input_2.txt
python process_field.py $BASE_DIR/tmp/train_input_2.txt  3 10 > $VALUE_FILE_BUCKET

echo -e "move the file :\n$VALUE_FILE_BUCKET \nTO \n$BASE_DIR/model/data_processed.txt\n"
## 将数据转移到模型目录 ./model/data_processed.txt
mv $VALUE_FILE_BUCKET $BASE_DIR/model/data_processed.txt
echo -e "success u can start to train the model...."



