class Rectangle {
    public int centerX, centerY, len, width, color;
    public PaintSetup ps;
    public Rectangle(int centerX, int centerY, int len, int width, int color) {
        this.centerX = centerX;
        this.centerY = centerY;
        ps = new PaintSetup(len, width, color);
    }
    static class PaintSetup {
        int colorPay;
        public PaintSetup(int len, int width, int color) {
            this.colorPay = (len*width)*color;
        }
    }
    public void paintCalculation(int len, int width, int color) {
        ps = new Rectangle.PaintSetup(len, width, color);
    }
}