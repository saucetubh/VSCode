// Main class containing the test code for the Vehicle hierarchy.
public class Main {
    public static void main(String[] args) {
        System.out.println("--- Testing Vehicle Class ---");
        // --- Test Vehicle Class ---
        Vehicle myVehicle = new Vehicle("Ford", 2020, 50, 60, 10, 150, 250, 5);
        myVehicle.printInfo();
        // Expected Output: Brand: Ford, Year: 2020, Max Speed: 150.0 mph, Horsepower: 250.0 hp
        System.out.println("Calculated Range: " + myVehicle.calculateRange());
        // Expected Output: Calculated Range: 500.0
        // --- Test Car Class ---
        System.out.println("--- Testing Car Class ---");
        Car myCar = new Car("Toyota", 2022, 40, 50, 12, 120, 180, 5, "Sedan");
        myCar.printInfo();
        // Expected Output: Type: Sedan, Passengers: 5, Fuel Left: 40.0, Efficiency: 12.0 mpg
        myCar.Honk();
        // Expected Output: Honk honk!
        // --- Test Bike Class ---
        System.out.println("--- Testing Bike Class ---");
        Bike myElectricBike = new Bike("Trek", 2023, 20, 20, 25, 20, 5, 1, true);
        myElectricBike.printInfo();
        // Expected Output: Type: Electric, Fuel Left/Charge: 20.0, Efficiency: 25.0 mpge
        System.out.println("Calculated Range: " + myElectricBike.calculateRange());
        // Expected Output: Calculated Range: 750.0
        myElectricBike.honk();
        // Expected Output: Ring ring!
        System.out.println();
        Bike myGasBike = new Bike("Harley-Davidson", 2021, 20, 20, 25, 20, 10, 1, false);
        System.out.println("Calculated Range (Gas): " + myGasBike.calculateRange());
        // Expected Output: Calculated Range (Gas): 500.0
        // --- Test Truck Class ---
        System.out.println("--- Testing Truck Class ---");
        Truck myTruck = new Truck("Volvo", 2019, 100, 150, 5, 90, 450, 2, 10000, 5000);
        myTruck.printInfo();
        // Expected Output: Max Weight Capacity: 10000.0 kg, Loaded Weight: 5000.0 kg, Fuel Left: 100.0, Efficiency: 5.0 mpg
        System.out.println("Calculated Range with Load: " + myTruck.calculateRange());
        // Expected Output: Calculated Range with Load: 375.0 -- how???
        myTruck.Honk();
        // Expected Output: Honk honk! Honk!
    }
}