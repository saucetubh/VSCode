interface comparable {
    boolean compareTo(Shape s);
}

abstract class Shape implements comparable {
    private String color;
    public Shape(String color) {
        this.color = color;
    }
    abstract double area();
    @Override
    public boolean compareTo(Shape o) {
        return (this.area() >= o.area());
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
    public static void main(String[] args) {
        Shape c1 = new Circle(2, "Red");
        Shape c2 = new Circle(3.0, "Green");
        Shape r1 = new Rectangle(3, 4, "Blue");
        Shape r2 = new Rectangle(4.0,5, "Black");
        System.out.println(c1.compareTo(c2));
        System.out.println(c1.compareTo(r1));
        System.out.println(c1.compareTo(r2));
        System.out.println(c2.compareTo(r1));
        System.out.println(c2.compareTo(r2));
        System.out.println(r1.compareTo(r2));
    }
}