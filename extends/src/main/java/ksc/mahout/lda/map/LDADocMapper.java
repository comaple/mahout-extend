package ksc.mahout.lda.map;

import ksc.mahout.util.Constant;
import ksc.mahout.writable.UidPrefWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.mahout.math.VectorWritable;

import java.io.IOException;

/**
 * Created by ZhangShengtao on 14-8-7.
 */
public class LDADocMapper extends Mapper<LongWritable, VectorWritable, Text, UidPrefWritable> {
    private static String FLAG = "doc";

    @Override
    protected void map(LongWritable key, VectorWritable value, Context context) throws IOException, InterruptedException {
        context.write(new Text(key.toString()), new UidPrefWritable(key.get(), Constant.FLAG_DOC, "0", value));

    }
}
