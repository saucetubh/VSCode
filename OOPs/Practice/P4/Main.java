class Shape {
    public void draw() {
        System.out.println("Drawing a shape");
    }
}
class Rectangle extends Shape {
    @Override
    public void draw() {
        System.out.println("Drawing a rectangle");
    }
}
class Circle extends Shape {
    @Override
    public void draw() {
        System.out.println("Drawing a circle");
    }
}
public class Main {
    public static void main(String[] args) {
    Shape s1 = new Rectangle();
    s1.draw();
    s1 = new Circle();
    s1.draw(); //simply updates the reference variable s1 to point to Circle object
}
}
