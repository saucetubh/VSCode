import java.io.*;
import java.util.*;

public class ShapeVis implements Runnable {
    private int strt, stp;
    private FourSidedSym fss;
    private ArrayList<Integer> dist;
    private File outFile;
    public ShapeVis(int strt, int stp, FourSidedSym fss, ArrayList<Integer> dist) {
        this.stp=stp;
        this.strt=strt;
        this.fss = fss;
        this.dist = dist;
        this.outFile = new File("out"+strt+".txt");
    }
    @Override 
    public void run() {
        try {
            movePnt();
        } catch (IOException e) {
        }
    }
    public void movePnt() throws IOException {
        FileWriter fw = new FileWriter(outFile);
        for(int i=strt; i<=stp; i++) {
            fss.setxPos(fss.getxPos() + dist.get(i)); 
            fw.write(Integer.toString(fss.getxPos()));
        }
        fw.close();
    }

}

class Shape {
    private int xPos;
    public Shape(int xPos) {
        this.xPos = xPos;
    }
    public int getxPos() {
        return this.xPos;
    }
    public void setxPos(int x) {
        this.xPos=x;
    }
}

class FourSidedSym extends Shape {
    public FourSidedSym(int xPos) {
        super(xPos);
    }
}