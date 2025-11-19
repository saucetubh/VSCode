import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Shape> shapes = new ArrayList<>();

        try {
            shapes.add(new Rectangle("Red", 5.0, 10.0));
            shapes.add(new Square("Blue", 7.0));
            shapes.add(new Circle("Green", 3.0));
            shapes.add(new Ellipse("Yellow", 8.0, 4.0));
        } catch (IllegalArgumentException e) {
            System.err.println("Error creating shape: " + e.getMessage());
            return;
        }

        for (Shape shape : shapes) {
            System.out.println("--------------------");
            shape.displayInfo();
        }
    }
}