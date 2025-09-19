public class Circle extends Shape {
    double radius;
    public static final double PI = Math.PI;
    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }
    @Override
    public double calculateArea() {
        return PI*Math.pow(radius, 2);
    }
    @Override
    public double calculatePerimeter() {
        return 2*PI*radius;
    }
}