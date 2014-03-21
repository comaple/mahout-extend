package ksc.mahout.kmeans.testvector;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.SequenceFile;
import org.apache.hadoop.io.Text;
import org.apache.mahout.math.DenseVector;
import org.apache.mahout.math.NamedVector;
import org.apache.mahout.math.VectorWritable;
import org.junit.Before;
import org.junit.Test;

import java.util.LinkedList;
import java.util.List;
import java.util.Random;

/**
 * Created by ZhangShengtao on 14-3-21.
 */
public class WriteVector {


    String[] names;
    int vectorLength;
    List<NamedVector> vectors;
    Random rd;

    @Before
    public void setUp() {
        names = new String[]{"test1,some words.",
                "test2,some words.",
                "test3,some words.",
                "test4,some words.",
                "test5,some words.",};
        vectorLength = 10;
        vectors = new LinkedList<NamedVector>();
        Random rd = new Random();
        NamedVector vector = null;
        for (int i = 0; i < vectorLength; i++) {
            vector = new NamedVector(new DenseVector(new double[]{rd.nextDouble(), rd.nextDouble(), rd.nextDouble()}), names[rd.nextInt(4)]);
            vectors.add(vector);
        }
    }

    @Test
    public void printVector() {
        for (NamedVector v : vectors) {
            System.out.println(v.getDelegate().asFormatString());
        }
    }

    @Test
    public void writeVectorToHDFS() throws Exception {
        Configuration conf = new Configuration();
        FileSystem fileSystem = FileSystem.get(conf);
        Path path = new Path("test/vector/data");
        SequenceFile.Writer writer = new SequenceFile.Writer(fileSystem, conf, path, Text.class, VectorWritable.class);
        VectorWritable vec = new VectorWritable();
        for (NamedVector vector : vectors) {
            vec.set(vector);
            writer.append(new Text(vector.getName()), vec);
        }
        writer.close();
    }

}
