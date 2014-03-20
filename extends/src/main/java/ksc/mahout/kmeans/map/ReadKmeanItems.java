package ksc.mahout.kmeans.map;

import ksc.mahout.util.Constant;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reporter;
import org.apache.mahout.clustering.classify.WeightedVectorWritable;
import org.apache.mahout.math.Arrays;
import org.apache.mahout.math.DenseVector;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by ZhangShengtao on 14-3-19.
 */
public class ReadKmeanItems extends Mapper<IntWritable, WeightedVectorWritable, Text, Text> {
    private int vectorLength = 0;

    @Override
    protected void setup(Context context) throws IOException, InterruptedException {
        vectorLength = context.getConfiguration().getInt(Constant.KMEANS_KCLASS, 0);
    }

    @Override
    protected void map(IntWritable key, WeightedVectorWritable value, Context context) throws IOException, InterruptedException {
//        System.err.println(value.getVector().toString());
        String vector = value.getVector().toString().replace("{", "").replace("}", "");
        // index : value
        String[] vlist = vector.split(",");
        String content = "";
        content = formateString(vlist, vectorLength);
//        if (vlist.length == vectorLength)
//            content = vector;
        System.err.println("---------------:" + content);
        context.write(new Text(key.toString()), new Text(content));
    }

    /**
     * 获取解析后的数据，按照字符串方式返回
     *
     * @param vlist
     * @param k
     * @return
     */
    private String formateString(String[] vlist, int k) {
        if (vlist.length <= 0)
            return "";
        StringBuilder stringBuilder = new StringBuilder();
        Map<Integer, String> indexValue = new HashMap<Integer, String>();
        for (String v : vlist) {
            String[] kv = v.split(":");
            if (kv.length != 2) {
                continue;
            }
            int index = Integer.parseInt(kv[0]);
            String value = kv[1];
            indexValue.put(index, value);
        }
        //uid of a user
        stringBuilder.append(String.format("%.0f", Float.parseFloat(indexValue.get(0))) + "\t");
        for (int i = 1; i < k; i++) {
            if (indexValue.containsKey(i)) {
//                stringBuilder.append(String.format("%.2f", indexValue.get(i)));

                stringBuilder.append(String.format("%.0f", Float.parseFloat(indexValue.get(i))));
            } else {
                stringBuilder.append("0");
            }
            stringBuilder.append("\t");
        }
        return stringBuilder.toString().trim();
    }

    public static void main(String[] args) {
        String[] vlist = new String[]{"2:133"
                , "4:245"
                , "8:4325"
                , "12:54365"};
        String msg = new ReadKmeanItems().formateString(vlist, 4);
        System.out.println(msg == "" ? Arrays.toString(vlist) : msg);
        WeightedVectorWritable weightedVectorWritable = new WeightedVectorWritable();
        weightedVectorWritable.setVector(new DenseVector(new double[]{124, 52, 46, 47, 98}));
        String value = weightedVectorWritable.getVector().toString();
        String vector = value.replace("{", "").replace("}", "");
        System.out.println(vector);


    }

}
