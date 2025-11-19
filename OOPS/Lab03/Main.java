public class Main {
    public static void main(String[] args) {
        // Create objects as specified in the lab
        Point p1 = new Point(0, 0);
        Point p2 = new Point(3, 0);
        Point p3 = new Point(0, 4);

        Triangle t1 = new Triangle(p1, p2, p3);

        System.out.println("Perimeter of the triangle: " + t1.getPerimeter());
        System.out.println("Area of the triangle: " + t1.getArea());
    }
}
