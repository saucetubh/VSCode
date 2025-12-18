import java.io.*;
import java.util.*;
public class SensorTask implements Runnable {
    private int fromIndex, toIndex;
    ArrayList<Double> readings = new ArrayList<>();
    File outFile;
    public SensorTask(int fromIndex, int toIndex, ArrayList<Double> readings) {
        this.fromIndex = fromIndex;
        this.toIndex = toIndex;
        this.readings = readings;
        this.outFile = new File("sensor_"+fromIndex+".dat");
    }
    @Override 
    public void run() {
        this.processReadings();
    }
    public void processReadings() {
        try {
            FileWriter fw = new FileWriter(outFile);
            for(int i=fromIndex; i<=toIndex; i++) {
                readings.set(i, Math.pow(readings.get(i),2));
                fw.write(Double.toString(readings.get(i)));
                fw.write('\n');
            }
            fw.close();
        }
        catch(IOException e) {
            throw new RuntimeException("Error");
        }
    }
}