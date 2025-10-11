abstract class Vehicle {
    private String brand;
    private int year;

    // Each Vehicle will have a nested VehicleRegistration object
    private VehicleRegistration registration;

    public Vehicle(String brand, int year, int registrationNo, String chasisNo, String ownerName) {
        this.brand = brand;
        this.year = year;
        this.registration = new VehicleRegistration(registrationNo, chasisNo, ownerName);
    }

    public abstract double calculateRange();

    public void printInfo() {
        System.out.println("Brand: " + brand);
        System.out.println("Year: " + year);
        registration.printRegistration(); // use nested class
    }

    // -------------------------
    // Nested Class (static or non-static?)
    // -------------------------
    public static class VehicleRegistration {
        private int registrationNo;
        private String chasisNo;
        private String ownerName;

        public VehicleRegistration(int registrationNo, String chasisNo, String ownerName) {
            this.registrationNo = registrationNo;
            this.chasisNo = chasisNo;
            this.ownerName = ownerName;
        }

        public void printRegistration() {
            System.out.println("Registration No: " + registrationNo);
            System.out.println("Chasis No: " + chasisNo);
            System.out.println("Owner Name: " + ownerName);
        }
    }
}

// -------------------------
// Subclass Example
// -------------------------
class Car extends Vehicle {
    private double fuelCapacity;
    private double efficiency;

    public Car(String brand, int year, int regNo, String chasisNo, String ownerName,
               double fuelCapacity, double efficiency) {
        super(brand, year, regNo, chasisNo, ownerName);
        this.fuelCapacity = fuelCapacity;
        this.efficiency = efficiency;
    }

    @Override
    public double calculateRange() {
        return fuelCapacity * efficiency;
    }
}

// -------------------------
// Usage in main
// -------------------------
public class Main {
    public static void main(String[] args) {
        Car c = new Car("Toyota", 2022, 12345, "CHS123", "John Doe", 40, 15);
        c.printInfo();
        System.out.println("Range: " + c.calculateRange());
    }
}
/*
// The outer class containing both types of nested classes
public class OuterClass {

    // 1. Static Nested Class (like a blueprint)
    public static class StaticNestedClass {
        public void showMessage() {
            System.out.println("Message from the static nested class.");
        }
    }

    // 2. Inner Class (like a specific car's engine)
    public class InnerClass {
        public void showMessage() {
            System.out.println("Message from the inner class.");
        }
    }

    // Main method to demonstrate instantiation
    public static void main(String[] args) {
        
        // === Instantiating the Static Nested Class ===
        // You can do this directly. No OuterClass object is needed.
        // The syntax is: OuterClass.NestedClassName variable = new OuterClass.NestedClassName();
        OuterClass.StaticNestedClass staticNestedObject = new OuterClass.StaticNestedClass();
        staticNestedObject.showMessage();


        // === Instantiating the Inner Class ===
        // This is a two-step process.

        // Step 1: You MUST create an instance of the OuterClass first.
        OuterClass outerObject = new OuterClass();

        // Step 2: Use the outer object to create the inner object. 
        // The syntax is: outerObjectReference.new InnerClassName();
        OuterClass.InnerClass innerObject = outerObject.new InnerClass();
        innerObject.showMessage();
    }
}
*/