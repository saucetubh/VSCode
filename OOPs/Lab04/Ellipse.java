public class Ellipse extends Shape {
    private double major_axis;
    private double minor_axis;

    public Ellipse(String color, double major_axis, double minor_axis) {
        super(color);
        if (major_axis <= 0 || minor_axis <= 0) {
            throw new IllegalArgumentException("Axes must be positive values.");
        }
        this.major_axis = major_axis;
        this.minor_axis = minor_axis;
    }

    @Override
    public double area() {
        return Math.PI * this.major_axis * this.minor_axis;
    }

    @Override
    public double perimeter() {
        return 2 * Math.PI * Math.sqrt((Math.pow(this.major_axis, 2) + Math.pow(this.minor_axis, 2)) / 2);
    }
}