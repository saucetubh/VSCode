public class Triangle {
    private Point point1, point2, point3;

    // Constructor given 6 coordinates
    public Triangle(int x1, int y1, int x2, int y2, int x3, int y3) {
        this.point1 = new Point(x1, y1);
        this.point2 = new Point(x2, y2);
        this.point3 = new Point(x3, y3);
    }

    // Constructor given 3 Point objects
    public Triangle(Point point1, Point point2, Point point3) {
        this.point1 = point1;
        this.point2 = point2;
        this.point3 = point3;
    }

    // Getters and Setters
    public Point getPoint1() {
        return point1;
    }

    public void setPoint1(Point point1) {
        this.point1 = point1;
    }

    public Point getPoint2() {
        return point2;
    }

    public void setPoint2(Point point2) {
        this.point2 = point2;
    }

    public Point getPoint3() {
        return point3;
    }

    public void setPoint3(Point point3) {
        this.point3 = point3;
    }
    
    // Method to calculate perimeter
    public double getPerimeter() {
        return point1.getDistance(point2) + point2.getDistance(point3) + point3.getDistance(point1);
    }

    // Method to calculate area using Heron's formula
    public double getArea() {
        double a = point1.getDistance(point2);
        double b = point2.getDistance(point3);
        double c = point3.getDistance(point1);
        double s = (a + b + c) / 2;
        return Math.sqrt(s * (s - a) * (s - b) * (s - c));
    }
}