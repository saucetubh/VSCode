/*
interface Comparable {
    public void compareTo(Rectangle o);
}
*/
class Rectangle implements Comparable<Rectangle> {
    int centreX, centreY, len, width, color;
    public Rectangle(int centreX, int centreY, int len, int width, int color) {
        this.centreX = centreX;
        this.centreY = centreY;
        this.len = len;
        this.width = width;
        this.color = color;
    }
    @Override
    public /*void*/ int compareTo(Rectangle o) {
        int areaT = this.len * this.width;
        int areaO = o.len * o.width;
        if(areaT < areaO) return -1; //System.out.println("-1");
        else if(areaT > areaO) return 1; //System.out.println("1");
        else return 0; //System.out.println("0");       
    }
}

public class Main2 {
    public static void main(String[] args) {
        Rectangle r1 = new Rectangle(100,100,10,10,2);
        Rectangle r2 = new Rectangle(100,100,20,20,2);
        r1.compareTo(r2);
        r2.compareTo(r1);
        r1.compareTo(r1);
    }
}