public class Ellipse extends Shape {
    double major_axis, minor_axis;
    public Ellipse(String color, double major_axis, double minor_axis) {
        super(color);
        this.major_axis = major_axis;
        this.minor_axis = minor_axis;
    }
    @Override
    public double calculateArea() {
        return (Math.PI)*major_axis*minor_axis;
    }
    @Override
    public double calculatePerimeter() {
        return 2*Math.PI*Math.sqrt((Math.pow(major_axis/2, 2)+Math.pow(minor_axis/2, 2))/2);
    }
}