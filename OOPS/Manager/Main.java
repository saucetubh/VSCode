abstract class Shape {
    String color;
    public Shape(String color) {
        this.color = color;
    }
    abstract double area();
    static class Utils {
        static double findmax(Shape[] arr) {
            double max = 0;
            for(Shape s : arr) {
                if(s.area() > max) max = s.area();
            }
            return max;
        }
    }
}

class Circle extends Shape {
    private final double PI = 3.14;
    private double r;
    public Circle(double r, String color) {
        super(color);
        this.r=r;
    }
    @Override 
    public double area() {
        return this.PI*this.r*this.r;
    }
}

class Rectangle extends Shape {
    private double l, w;
    public Rectangle(double l, double w, String color) {
        super(color);
        this.l=l;
        this.w=w;
    }
    @Override
    public double area() {
        return l*w;
    }
}

public class Main {
    class Printer {
        void print(Shape[] arr) {
            for(Shape s : arr) {
                System.out.println(s.color+" "+ s.area()+"\n"); //if color private then use getter method for color
            }
        }
    }
    public static void main(String[] args) {
    Shape c1 = new Circle(2, "Red");
    Shape c2 = new Circle(3.0, "Green");
    Shape r1 = new Rectangle(3, 4, "Blue");
    Shape r2 = new Rectangle(4.0,5, "Black");
    Shape[] arr = {c1, c2, r1, r2};
    Main.Printer p = new Main().new Printer();
    p.print(arr);
    System.out.println("Largest: " +Shape.Utils.findmax(arr));
    }

}