class Shape {
    private int sides;
    private String name;
    public Shape (int sides, String name) {
        this.sides = sides;
        this.name = name;
    }
    /*
    public static void printShapes(Shape S) {
        System.out.println("No.of sides: " +S.sides);
        System.out.println("Shape name: " +S.name);
    }
    */
    public void printShapes() {
        System.out.println("No.of sides: " + this.sides);
        System.out.println("Shape name: " + this.name);
    }
}
public class Stuff {
    public static void main(String[] args) {
        /*
        Scanner sc = new Scanner(System.in);
        System.out.println("Square root of 2: " + Math.sqrt(2));
        System.out.println("2 raised to the power of 3: " + Math.pow(2, 3));
        System.out.println("Value of PI: " + Math.PI);
        final float pi = 3.14f; //it is necessary to use 'f' for float literals
        System.out.println("Value of PI: " + pi);
        String s1 = "Hello World";
        String s2 = new String("Hello Earth");
        String s3 = s1 + s2;
        String s4 = s1.concat(s2);
        char c1 = s1.charAt(4);
        char c2 = s2.charAt(3);
        //String s5 = s3[0]; this is not valid, strings are not arrays
        char c3 = s3.charAt(0);
        char c4 = s4.charAt(0);
        String[] names = {s1, s2, s3, s4};
        char[] letters = {c1, c2, c3, c4};
        int[] numbers = new int[5];
        for (int i=0; i<numbers.length; i++) {
            numbers[i] = i * 10;
        }
        System.out.println(s1);
        System.out.println(s2);
        System.out.println(s3);
        System.out.println(s4);
        System.out.println(c1);
        System.out.println(c2);
        System.out.println(numbers.length);
        for (int i=0; i<=3; i++) {
            System.out.println(names[i]);
            System.out.println(letters[i]);
            System.out.println(numbers[i]);
        }
        */
        Shape[] shapes = new Shape[3];
        shapes[0] = new Shape(3, "Triangle");
        shapes[1] = new Shape(4, "Square");
        shapes[2] = new Shape(5, "Pentagon");
        /*
        for(int i=0; i<shapes.length; i++) {
            Shape.printShapes(shapes[i]); //since it is a static method i can use it with the class name
        }
        */
        for(int i=0; i<shapes.length; i++) {
            shapes[i].printShapes(); 
        }
    }
}

/*
static functions and variables are shared among all instances of a class, i.e. they are common to a class and may or may not be common between objects.
instance variables and methods are unique to each instance of a class, i.e. they are specific to an object of the class.
static functions cannot access instance variables or methods directly.
instance methods can access instance variables and methods.
instance methods can also access static variables and methods since they belong to the class.
static methods and variables can be accessed by just using the class name.

initializer block - it's a piece of code that runs when an instance of a class (i.e. an object) is created.
There are two types - static and non-static.
A non-static initializer block will run the code inside whenever an instance of the class (object) is created.
A static initializer block will run the code inside only once when the class is loaded.
static {
    // code to be executed when the class is loaded
}

constructors run in order from parent to child (superclass constructor runs before subclass constructor).
*/
