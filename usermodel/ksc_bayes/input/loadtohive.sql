
if [ $# != 1 ]
then
echo please use day as u parmeter like 20140308 .
exit
fi
tablename=ksckd.kp_mid
dt=$1

python  fit_field.py   kp_userpreference.txt > kp_userpreference_new 
python caculate_train.py kp_userpreference_new > kp_userpreference_hive

hive -e "LOAD DATA LOCAL INPATH 'kp_userpreference_hive' OVERWRITE INTO TABLE $tablename PARTITION (day=$dt)"
