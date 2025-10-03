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