package ksc.mahout.kmeans.main;

import ksc.mahout.kmeans.map.ReadHiveMapper;
import ksc.mahout.kmeans.map.ReadHiveMapper2;
import ksc.mahout.kmeans.reduce.ReadHiveReducer;
import ksc.mahout.kmeans.reduce.ReadHiveReducer2;
import ksc.mahout.util.Constant;
import org.apache.hadoop.hive.metastore.api.ThriftHiveMetastore;
import org.apache.hadoop.hive.ql.io.RCFileInputFormat;
import org.apache.hadoop.hive.ql.io.RCFileOutputFormat;
import org.apache.hadoop.hive.serde2.columnar.BytesRefArrayWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;

import org.apache.hadoop.mapred.*;
import org.apache.hadoop.mapreduce.Job;

import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;

import org.apache.hadoop.mapreduce.lib.output.SequenceFileOutputFormat;
import org.apache.hadoop.util.ToolRunner;
import org.apache.mahout.common.AbstractJob;
import org.apache.mahout.common.commandline.DefaultOptionCreator;

/**
 * Created by ZhangShengtao on 14-4-14.
 */
public class ReadHiveAsSequenceFile extends AbstractJob {

    public static String JOB_NAME = "TransFromHive2Seq-Job-State-I";
    public static String isRCFile = "isRCFile";
    public static String REDUCE_TASK = "reduce";


    public static void main(String[] args) throws Exception {
        ToolRunner.run(new ReadHiveAsSequenceFile(), args);
    }

    @Override
    public int run(String[] args) throws Exception {
        //add the arguments
        addOptions();
        // parse the arguments
        if (parseArguments(args) == null) {
            return -1;
        }
        return runMapReduce();
    }


    private int runMapReduce() throws Exception {

        int reduce_task = Integer.parseInt(getOption(REDUCE_TASK, "5"));

        boolean RCfile = Boolean.parseBoolean(getOption(isRCFile, "false"));
        if (RCfile) {
            JobConf jobconf = new JobConf(getConf());
            jobconf.setInputFormat(RCFileInputFormat.class);

            jobconf.setJarByClass(ReadHiveAsSequenceFile.class);
            jobconf.setMapperClass(ReadHiveMapper2.class);
            jobconf.setReducerClass(ReadHiveReducer2.class);
            jobconf.setMapOutputKeyClass(Text.class);
            jobconf.setMapOutputValueClass(Text.class);
            jobconf.setOutputKeyClass(Text.class);
            jobconf.setOutputValueClass(Text.class);
            jobconf.setNumReduceTasks(reduce_task);
            FileInputFormat.setInputPaths(jobconf, getInputPath());
            FileOutputFormat.setOutputPath(jobconf, getOutputPath());
            RunningJob job = JobClient.runJob(jobconf);
            job.waitForCompletion();
            return 0;
        } else {
            Job readHiveAsSeqJob = prepareJob(getInputPath(),
                    getOutputPath(),
                    TextInputFormat.class,
                    ReadHiveMapper.class,
                    Text.class,
                    Text.class,
                    ReadHiveReducer.class,
                    Text.class,
                    Text.class,
                    SequenceFileOutputFormat.class
            );

            readHiveAsSeqJob.setNumReduceTasks(reduce_task);
            readHiveAsSeqJob.setJobName(JOB_NAME);
            return readHiveAsSeqJob.waitForCompletion(true) ? 0 : -1;
        }

    }


    private void addOptions() {
        addInputOption();
        addOutputOption();
        addOption(DefaultOptionCreator.overwriteOption().create());
        addOption(isRCFile, "rc", "is RCFile or not.");

    }

}
