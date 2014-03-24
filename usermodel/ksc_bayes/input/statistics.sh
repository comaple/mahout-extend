
filename=$1

registtypeList=$(cat kp_userpreference.txt |cut -f 8|sort|uniq)
terminalList=$(cat kp_userpreference.txt |cut -f 7|sort|uniq)
fieldList='registtype terminal'

for rtype in $registtypeList
do 
echo $rtype
cat $filename | awk '{if($8 == rtype){print $1,$2,$3,$4,$5,$6}}' rtype=$rtype \
> statistics_registtype/registtype_$rtype
done

for rtype in $terminalList
do
echo $rtype
cat $filename | awk '{if($7 == rtype){print $1,$2,$3,$4,$5,$6}}' rtype=$rtype \
> statistics_terminal/terminal_$rtype
done

find . -name '*_process*' |xargs rm -rf

echo 'fit field for registtype'
for i in $(ls statistics_registtype/); do python fit_field.py statistics_registtype/$i > statistics_registtype/${i}_process ;done

echo 'fit field for terminal'
for i in $(ls statistics_terminal/); do python fit_field.py statistics_terminal/$i > statistics_terminal/${i}_process ;done

find . -name '*final' |xargs rm -rf
echo "" > ./statistics_terminal/final
echo ............ statistics ............
for i in  $(find ./statistics_terminal -name '*_process')
do
echo $i >> ./statistics_terminal/final
python caculate_train.py  $i >> ./statistics_terminal/final
done

echo "" > ./statistics_registtype/final
for i in  $(find ./statistics_registtype -name '*_process')
do
echo $i >> ./statistics_registtype/final
python caculate_train.py $i >> ./statistics_registtype/final
done

