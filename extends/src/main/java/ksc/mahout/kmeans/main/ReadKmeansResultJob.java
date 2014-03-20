package ksc.mahout.kmeans.main;


import ksc.mahout.kmeans.map.ReadKResults;
import ksc.mahout.kmeans.map.ReadKmeanItems;
import ksc.mahout.util.Constant;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;

import org.apache.hadoop.mapred.lib.IdentityReducer;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.ToolRunner;
import org.apache.mahout.common.AbstractJob;
import org.apache.mahout.common.HadoopUtil;
import org.apache.mahout.common.commandline.DefaultOptionCreator;
import sun.security.krb5.internal.HostAddress;


/**
 * Created by ZhangShengtao on 14-3-19.
 */
public class ReadKmeansResultJob extends AbstractJob {

    public static String JOB_NAME_1 = "KmeansResultTransform-Job-State-I";
    public static String JOB_NAME_2 = "KmeansResultTransform-Job-State-II";
    public static String KMEANS_RESULT = "output_rest";

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
        return runMapReduce();
    }

    private int runMapReduce() throws Exception {
        String inputKmeanItemsPath = "clusteredPoints";
        HadoopUtil.delete(getConf(), getOutputPath());
        int k = Integer.parseInt(getOption(Constant.KMEANS_KCLASS));
        Path inputKmeansFinalPath = new Path(getInputPath().toString() + Path.SEPARATOR + inputKmeanItemsPath);
        // read kmeans items from the result of the mahout
        Job readKmeansItemsJob = prepareJob(inputKmeansFinalPath,
                getOutputPath(),
                SequenceFileInputFormat.class,
                ReadKmeanItems.class,
                Text.class,
                Text.class,
                TextOutputFormat.class,
                JOB_NAME_1);
        readKmeansItemsJob.getConfiguration().set("mapred.output.compress", "false");
        readKmeansItemsJob.getConfiguration().setInt(Constant.KMEANS_KCLASS, k);
        boolean isComplete_Items = readKmeansItemsJob.waitForCompletion(true);
        String inputKResultPath = "clusters-*-final";
        Path inputKResultFinalPath = new Path(getInputPath().toString() + Path.SEPARATOR + inputKResultPath);
        Path outputKResultFinalPath = new Path(getOption(KMEANS_RESULT));
        HadoopUtil.delete(getConf(), outputKResultFinalPath);
        // read the result from the mahout kmeans
        Job readKResultJob = prepareJob(inputKResultFinalPath,
                outputKResultFinalPath,
                SequenceFileInputFormat.class,
                ReadKResults.class,
                Text.class,
                Text.class,
                TextOutputFormat.class,
                JOB_NAME_2);
        readKResultJob.getConfiguration().set("mapred.output.compress", "false");
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
        addOption(KMEANS_RESULT, "ro", "the result of kmeans output,whitch number is k.", true);
        addOption(Constant.KMEANS_KCLASS, "k", "the class u data have", true);
        addOption(DefaultOptionCreator.overwriteOption().create());
    }
}
