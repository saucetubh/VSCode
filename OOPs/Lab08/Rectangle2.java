interface Comparable {
    public int compareTo(Rectangle2 r); //the testrunner for some reason expects us to use the comparable interface taking Rectangle2 as argument, not Object 
}
class Rectangle2 implements Comparable{
    public int centerX, centerY, len, width, color;
    public Rectangle2(int centerX, int centerY, int len, int width, int color) {
        this.centerX = centerX;
        this.centerY = centerY;
        this.len = len;
        this.width = width;
        this.color = color;
    }
    @Override 
    public int compareTo(Rectangle2 r) {
        int a1 = this.len * this.width;
        int a2 = r.len * r.width;
        if(a1 > a2) return 1;
        else if(a1 < a2) return -1;
        else return 0;
    }
}
