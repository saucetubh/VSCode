public class Rectangle extends Shape {
    double width;
    double length;
    public Rectangle(String color, double width, double length) {
        super(color);
        this.width = width;
        this.length = length;
    }
    @Override
    public double calculateArea() {
        return width * length;
    }
    @Override
    public double calculatePerimeter() {
        return 2*(width+length);
    }
    
}