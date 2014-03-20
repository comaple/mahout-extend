
dt=$(date +"%Y%m%d")
#nohup mahout org.apache.mahout.clustering.syntheticcontrol.kmeans.Job -i /user/ksckd/usermodel/kmeans/input/* -o /user/ksckd/usermodel/kmeans/output/  -dm EuclideanDistanceSimilarity  -x 20 -ow true > kmeans_$dt.log &

nohup mahout org.apache.mahout.clustering.syntheticcontrol.kmeans.Job --input /user/ksckd/usermodel/kmeans/input/* --output /user/ksckd/usermodel/kmeans/output/  --distanceMeasure org.apache.mahout.common.distance.SquaredEuclideanDistanceMeasure --maxIter 20 -t1 0.4 -t2 0.2 -ow -k 5 > kmeans_$dt.log&


