// This file demonstrates method overloading in Java.
// Method overloading is a feature that allows a class to have more than one method
// with the same name, as long as their parameter lists are different.
// The compiler determines which method to call based on the number, type,
// and order of the arguments.

public class MethodOverloading {

  // Method to add two integers
  public int add(int a, int b) {
    System.out.println("Executing add(int, int)");
    return a + b;
  }

  // Overloaded method to add two doubles
  public double add(double a, double b) {
    System.out.println("Executing add(double, double)");
    return a + b;
  }

  // Overloaded method to add three integers
  public int add(int a, int b, int c) {
    System.out.println("Executing add(int, int, int)");
    //implement the logic for this here
    return 0;
  }

  // Implement an Overloaded method to add two strings
  // Write the function declaration and the definition
  // Function should return the concatenation of the two strings

  public static void main(String[] args) {
    // Create an instance of the class
    MethodOverloading mo = new MethodOverloading();

    // Call the overloaded methods with different arguments
    System.out.println("Result of adding two integers (10, 20): " + mo.add(10, 20));
    System.out.println(); // Add a newline for better readability

    System.out.println("Result of adding two doubles (10.5, 20.5): " + mo.add(10.5, 20.5));
    System.out.println();

    //System.out.println("Result of adding three integers (10, 20, 30): " + mo.add(10, 20, 30));
    //System.out.println();

    //System.out.println("Result of adding two strings ('Hello', ' World'): " + mo.add("Hello", " World"));
  }

}
