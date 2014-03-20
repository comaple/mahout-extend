package ksc.mahout.kmeans.map;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.mahout.clustering.iterator.ClusterWritable;

import java.io.IOException;

/**
 * Created by ZhangShengtao on 14-3-19.
 */
public class ReadKResults extends Mapper<IntWritable, ClusterWritable, Text, Text> {

    @Override
    protected void map(IntWritable key, ClusterWritable value, Context context) throws IOException, InterruptedException {
        value.toString();
        context.write(new Text(""), new Text(value.toString()));
    }
}
