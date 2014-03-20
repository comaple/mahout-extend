package ksc.mahout.kmeans.map;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mrunit.MapDriver;
import org.apache.hadoop.mrunit.MapReduceDriver;
import org.apache.hadoop.mrunit.ReduceDriver;
import org.apache.mahout.clustering.classify.WeightedVectorWritable;
import org.junit.Before;
import org.junit.Test;


/**
 * Created by ZhangShengtao on 14-3-20.
 */
public class ReadKmeansItemsMapTestCase {
    MapDriver<IntWritable, WeightedVectorWritable, Text, Text> mapDriver;
    MapReduceDriver<IntWritable, WeightedVectorWritable, Text, Text, Text, Text> mapReduceDriver;

    @Before
    public void setUp() {
        ReadKmeanItems readKmeanItemsMaper = new ReadKmeanItems();
//        mapDriver = new MapDriver<IntWritable, WeightedVectorWritable, Text, Text>(readKmeanItemsMaper);
    }

    @Test
    public void testMaper() {

    }
}
