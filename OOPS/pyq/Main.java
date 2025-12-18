import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {

        // Initial shape position
        FourSidedSym fss = new FourSidedSym(0);

        // Distance list
        ArrayList<Integer> dist = new ArrayList<>();
        dist.add(2);
        dist.add(3);
        dist.add(-1);
        dist.add(4);

        // ShapeVis task
        ShapeVis sv = new ShapeVis(0, 3, fss, dist);

        // Run as thread
        Thread t = new Thread(sv);
        t.start();

        System.out.println("Thread started. Check output file.");
    }
}