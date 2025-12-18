import java.util.*;
public class Main {
    public static void main(String[] args) {
        ArrayList<Double> readings = new ArrayList<>();
        readings.add(10.2);
        readings.add(4.0);
        readings.add(0.4);
        readings.add(20.2);
        readings.add(3.0);
        SensorTask st1 = new SensorTask(1,4,readings);
        SensorTask st2 = new SensorTask(2,4,readings);
        Thread thr1 = new Thread(st1);
        Thread thr2 = new Thread(st2);
        thr1.start();
        try {
            thr1.join(); //this basically means thr2 first waits for thr1 to finish and then thr2 starts
        } catch (InterruptedException e) {
        }
        thr2.start();
    }
}