package ksc.mahout.kmeans.main;


import ksc.mahout.kmeans.map.ReadKResults;
import ksc.mahout.kmeans.map.ReadKmeanItems;
import org.apache.hadoop.io.Text;

import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.ToolRunner;
import org.apache.mahout.common.AbstractJob;
import org.apache.mahout.common.HadoopUtil;
import org.apache.mahout.common.commandline.DefaultOptionCreator;

/**
 * Created by ZhangShengtao on 14-3-19.
 */
public class ReadKmeansResultJob extends AbstractJob {
    public static String JOB_NAME = "KmeansResultTransform-Job";

    public static void main(String[] args) throws Exception {
        ToolRunner.run(new ReadKmeansResultJob(), args);
    }

    @Override
    public int run(String[] args) throws Exception {
        //add the arguments
        addOptions();
        // parse the arguments
        if (parseArguments(args) == null) {
            return -1;
        }
        return 0;
    }

    private int runMapReduce() throws Exception {
        HadoopUtil.delete(getConf(), getInputPath());
        // read kmeans items from the result of the mahout
        Job readKmeansItemsJob = prepareJob(getInputPath(),
                getOutputPath(),
                SequenceFileInputFormat.class,
                ReadKmeanItems.class,
                Text.class,
                Text.class,
                TextOutputFormat.class,
                JOB_NAME);
        boolean isComplete_Items = readKmeansItemsJob.waitForCompletion(true);

        // read the result from the mahout kmeans
        Job readKResultJob = prepareJob(getInputPath(),
                getOutputPath(),
                SequenceFileInputFormat.class,
                ReadKResults.class,
                Text.class,
                Text.class,
                TextOutputFormat.class,
                JOB_NAME);
        boolean isComplete_Result = false;
        if (isComplete_Items) {
            isComplete_Result = readKResultJob.waitForCompletion(true);
        }
        // is complete the read result successful
        return isComplete_Items && isComplete_Result ? 1 : 0;
    }

    private void addOptions() {
        addInputOption();
        addOutputOption();
        addOption(DefaultOptionCreator.overwriteOption().create());
    }
}
