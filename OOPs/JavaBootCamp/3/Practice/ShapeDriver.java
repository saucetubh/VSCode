public class ShapeDriver {
  public static void main(String[] args) {

    Shape[] shapes = new Shape[2];
    shapes[0] = new Circle(5.0); // An object of Circle is assigned to a Shape reference.
    shapes[1] = new Rectangle(4.0, 6.0); // An object of Rectangle is assigned to a Shape reference.

    for (Shape shape : shapes) {
      double area = shape.calculateArea();
      System.out.println("The area is: " + area);
      System.out.println(); // Add a blank line for readability
    }
    
  }
}