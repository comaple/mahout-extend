
sudo cp /home/zhangshengtao/ReadKmeans.jar ./

hadoop  jar ReadKmeans.jar -i /user/ksckd/usermodel/kmeans/output -k 7 -o /user/ksckd/usermodel/kmeans/result/result_items --output_rest /user/ksckd/usermodel/kmeans/result/result_k

hadoop fs -ls /user/ksckd/usermodel/kmeans/result/result_items/part-m-00000

rm -rf part-m-00000

hadoop fs -get /user/ksckd/usermodel/kmeans/result/result_items/part-m-00000 ./
