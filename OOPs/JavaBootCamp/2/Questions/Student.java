class Student {
    private String name;
    private int rollNumber; // Defaults to 0
    private double gpa; // Defaults to 0.0
public Student(String name, int rollNumber, double gpa) {
    this.name = name;
    this.rollNumber = rollNumber;
    this.gpa = gpa;
}
public Student(String name, int rollNumber) { //overloading constructor with a different signature
/*
this.name = name;
this.rollNumber = rollNumber;
this.gpa = 0.0;
*/ //this is inefficient
    this(name, rollNumber, 0.0); //this is an alternate way to assign values to fields. This is possible because of the first constructor we made
} //we are basically calling the first constructor from the second one
public Student(String name) {
    this(name, 0, 0.0);
}
public void displayInfo() {
    System.out.println("Name: " + name);
    System.out.println("Roll Number: " + rollNumber);
    System.out.println("CGPA: " + gpa);
}

    /*
        The main method for this class describes its intended functionality.

        Specifically, it demonstrates the different approaches which we want the
        user to be able to employ to intialise objects of the class.

        TODO:
        Create appropriate constructors and methods to make these initialisation
        approaches possible.
        You may need to use more than one constructor.

        Follow Up:
        Notice how many instances of the 'this' keyword you have used while writing constructors.
        Is it possible to create all required constructors using only 5 such instances?

        Follow Up 2:
        Notice the access specifiers which have been used in this class.
        Are they appropriate? If not, what changes need to be made?
    */

    // Write your functions here:

    public static void main(String[] args) {
        Student s1 = new Student("Alice", 101, 3.8); // Name, Roll Number, CGPA
        Student s2 = new Student("Bob", 102); // Name, Roll Number
        Student s3 = new Student("Catherine"); // Name

        s1.displayInfo(); // Expected: Name: Alice, Roll Number: 101, CGPA: 3.8
        s2.displayInfo(); // Expected: Name: Bob, Roll Number: 102, CGPA: 0.0
        s3.displayInfo(); // Expected: Name: Catherine, Roll Number: 0, CGPA: 0.0
    }
}

//in OOPS you only want to expose the API (Application Programming Interface) to the users of your class
//This means you should keep the internal implementation details hidden and only show the methods and properties that are necessary for the user to interact with the class.
//Hence variables should be used with the private access modifier