public class ShapeDriver {
  public static void main(String[] args) {

    Shape[] shapes = new Shape[2];
    shapes[0] = new Circle(5.0); // An object of Circle is assigned to a Shape reference.
    shapes[1] = new Rectangle(4.0, 6.0); // An object of Rectangle is assigned to a Shape reference.
    //Circle circle = new Shape(); //this error will be compile time
    for (Shape shape : shapes) {
      double area = shape.calculateArea();
      System.out.println("The area is: " + area);
      System.out.println(); // Add a blank line for readability
    }
    //int[] array = new int[-5]; //this error will be run time
    //Object obj = "hELLO"; 
    //Integer num = (Integer) obj; //this error will be run time //since it isnt showing red squiggly line its obvious this isnt compile time error

  }
}