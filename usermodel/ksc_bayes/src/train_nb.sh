RATE=$1

echo use $PATE ,to split data ...
python split.py  -i ../model/data_processed.txt -p ../model/data -r $RATE

echo training ....

python nb.py 1 ../model/data_train ../model/data_model

echo testing ....

python nb.py 0 ../model/data_test ../model/data_model ../model/data_out

echo success ....
