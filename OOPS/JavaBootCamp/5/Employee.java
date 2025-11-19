// In UML diagrams:
//+ means public, - means private, # means protected
//underlines means static
//all caps mean final
public class Employee {
    private String name;
    private double payRate;
    private final int EMPLOYEE_ID;
    public static int nextID = 1;
    public static final double STARTING_PAY_RATE = 50000.0;

    // Constructor with name only
    public Employee(String name) {
        this.name = name;
        this.payRate = STARTING_PAY_RATE;
        this.EMPLOYEE_ID = getNextID();
    }

    // Constructor with name and payRate
    public Employee(String name, double payRate) {
        this.name = name; //name = name; also works but this is clearer
        this.payRate = payRate;
        this.EMPLOYEE_ID = getNextID();
    }

    public String getName() {
        return name;
    }

    public int getEmployeeID() {
        return EMPLOYEE_ID;
    }

    public double getPayRate() {
        return payRate;
    }

    public void changeName(String newName) {
        this.name = newName;
    }

    public void changePayRate(double newPayRate) {
        this.payRate = newPayRate;
    }

    public static int getNextID() {
        return nextID;
    }
}