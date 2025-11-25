class Rectangle {
    public int centreX, centreY, len, width, color;
    PaintSetup ps;
    public Rectangle(int centreX, int centreY, int len, int width, int color) {
        this.centreX = centreX;
        this.centreY = centreY;
        this.len = len;
        this.width = width;
        this.color = color;
    }
    static class PaintSetup {
        public int colorPay;
        public PaintSetup(int len, int width, int color) {
            this.colorPay = len * width * color;
        }
    }
    public void paintCalculation(int len, int width, int color) {
       this.ps = new Rectangle.PaintSetup(len, width, color); //this.ps = new PaintSetup(len, width, color); //also works 
    }
}

public class Main1 {
    public static void main(String[] args) {
        Rectangle r1 = new Rectangle(100,100,10,10,2);
        r1.paintCalculation(10,10,2);
        System.out.println(r1.ps.colorPay);
    }
}