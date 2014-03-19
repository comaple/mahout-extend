
hadoop jar mahout-util-1.0-SNAPSHOT.jar -i /temp/mahout/rawdata/ -o /temp/mahout/seq-data
 exit

#mahout seqdirectory -i /temp/mahout/train-data/ -o /temp/mahout/train-seq/
#mahout seq2sparse -i /temp/mahout/train-seq/ -o /temp/mahout/train-vector/ -lnorm -nv  -wt tfidf
#mahout split -i /temp/mahout/train-vector/tfidf-vectors --trainingOutput /temp/mahout/train/  --testOutput /temp/mahout/test/ --randomSelectionPct 40 --overwrite --sequenceFiles -xm sequential
#mahout trainnb -i  /temp/mahout/train -el -o /temp/mahout/model -li /temp/mahout/labelindex -ow -c
mahout trainnb -i  /temp/mahout/train-vector/tfidf-vectors -el -o /temp/mahout/model -li /temp/mahout/labelindex -ow -c

mahout testnb -i /temp/mahout/train-vector/tfidf-vectors -m /temp/mahout/model -l /temp/mahout/labelindex -ow -o
 /temp/mahout/testing-result

