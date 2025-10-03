// Main class containing the test code for the Vehicle hierarchy.
public class Main {
    public static void main(String[] args) {
        // --- Test Car Class ---
        System.out.println("--- Testing Car Class ---");
        Car myCar = new Car("Toyota", 2022, 40, 50, 12, 120, 180, 5, "Sedan", 1873, "CHS123456789", "Alice Smith"); //constructor of Car class takes individual fields of VehicleRegistration class as parameters and makes the vehReg object by itself inside, so we pass those fields here
        myCar.printInfo();
        // Expected Output: Type: Sedan, Passengers: 5, Fuel Left: 40.0, Efficiency: 12.0 mpg
        myCar.Honk();
        // Expected Output: Honk honk!
        // --- Test Bike Class ---
        System.out.println("--- Testing Bike Class ---");
        Bike myElectricBike = new Bike("Trek", 2023, 20, 20, 25, 20, 5, 1, true, 9876, "CHS987654321", "Bob Johnson"); //constructor of Bike class takes individual fields of VehicleRegistration class as parameters and makes the vehReg object by itself inside, so we pass those fields here
        myElectricBike.printInfo();
        // Expected Output: Type: Electric, Fuel Left/Charge: 20.0, Efficiency: 25.0 mpge
        System.out.println("Calculated Range: " + myElectricBike.calculateRange());
        // Expected Output: Calculated Range: 750.0
        myElectricBike.honk();
        // Expected Output: Ring ring!
        System.out.println();
        Bike myGasBike = new Bike("Harley-Davidson", 2021, 20, 20, 25, 20, 10, 1, false, 1234, "CHS123456789", "Pratham Ladoo");
        System.out.println("Calculated Range (Gas): " + myGasBike.calculateRange());
        // Expected Output: Calculated Range (Gas): 500.0
        // --- Test Truck Class ---
        System.out.println("--- Testing Truck Class ---");
        Vehicle.VehicleRegistration truckReg = new Vehicle.VehicleRegistration(12345, "CHS123456789", "John Doe"); //creating object of nested class VehicleRegistration, since it is static, we can create its object without creating object of outer class Vehicle
        /*
        If it was non-static nested class, we would have to do this:
        Vehicle outer = new Vehicle(...); //create object of outer class first
        Vehicle.VehicleRegistration truckReg = outer.new VehicleRegistration(...); //then create object of nested class
        */
        Truck myTruck = new Truck("Volvo", 2019, 100, 150, 5, 90, 450, 2, 10000, 5000, truckReg); //since constructor of truck class takes object of VehicleRegistration class as parameter, we create the object of VehicleRegistration class in main method and pass it to Truck constructor
        myTruck.printInfo();
        // Expected Output: Max Weight Capacity: 10000.0 kg, Loaded Weight: 5000.0 kg, Fuel Left: 100.0, Efficiency: 5.0 mpg
        System.out.println("Calculated Range with Load: " + myTruck.calculateRange());
        // Expected Output: Calculated Range with Load: 375.0 -- how???
        myTruck.Honk();
        // Expected Output: Honk honk! Honk!
        // --- Test Comparable Implementation ---
        Vehicle[] vehicles = {myCar, myElectricBike, myGasBike, myTruck};
        for (int i = 0; i < vehicles.length; i++) {
            for (int j = i + 1; j < vehicles.length; j++) {
                if (vehicles[i].compareTo(vehicles[j]) > 0) {
                    // Swap vehicles[i] and vehicles[j]
                    Vehicle temp = vehicles[i];
                    vehicles[i] = vehicles[j];
                    vehicles[j] = temp;
                }
            }
        }
        System.out.println("--- Vehicles Sorted by Horsepower ---");
        for (Vehicle v : vehicles) {
            System.out.println(v.getBrand() + " - Horsepower: " + v.getHorsePower());
        }
        //Now sorting on the basis of owner name. Since my compareto interface is for double, i would need another interface for string comparison, or i can just directly do a bubble sort here based on owner name
        for(int i = 0; i < vehicles.length; i++) {
            for(int j = i+1; j < vehicles.length; j++) {
                String ownerName1 = "";
                String ownerName2 = "";
                if(vehicles[i] instanceof Car) { //this is important, since vehicles[i] is of Vehicle reference type, it does not have getVehReg() method, so we need to typecast it to its actual object type first
                    ownerName1 = ((Car) vehicles[i]).getVehReg().getOwnerName();
                }
                else if(vehicles[i] instanceof Bike) {
                    ownerName1 = ((Bike) vehicles[i]).getVehReg().getOwnerName();
                }
                else if(vehicles[i] instanceof Truck) {
                    ownerName1 = ((Truck) vehicles[i]).getVehReg().getOwnerName();
                }
                if(vehicles[j] instanceof Car) {
                    ownerName2 = ((Car) vehicles[j]).getVehReg().getOwnerName();
                }
                else if(vehicles[j] instanceof Bike) {
                    ownerName2 = ((Bike) vehicles[j]).getVehReg().getOwnerName();
                }
                else if(vehicles[j] instanceof Truck) {
                    ownerName2 = ((Truck) vehicles[j]).getVehReg().getOwnerName();
                }
                if(ownerName1.compareTo(ownerName2) > 0) { //if owner name of vehicle i comes after owner name of vehicle j alphabetically, then swap
                    Vehicle temp = vehicles[i]; //compareTo function used here is actually the compareTo function of String class which compares two strings lexicographically
                    vehicles[i] = vehicles[j];
                    vehicles[j] = temp;
                }
            }
        } //clearly this is not a good way to do it, it is better to implement using an interface
        System.out.println("--- Vehicles Sorted by Owner Name ---");
        for(Vehicle v : vehicles) {
            String ownerName = "";
            if(v instanceof Car) {
                ownerName = ((Car) v).getVehReg().getOwnerName();
            }
            else if(v instanceof Bike) {
                ownerName = ((Bike) v).getVehReg().getOwnerName();
            }
            else if(v instanceof Truck) {
                ownerName = ((Truck) v).getVehReg().getOwnerName(); //all this is necessary since Vehicle class does not have getVehReg() method, only its subclasses do so to access that method, we need to typecast it to its actual object type first
            }
            System.out.println(v.getBrand() + " - Owner Name: " + ownerName); //to avoid all this typecasting, we can make getVehReg() method in Vehicle class itself, and override it in subclasses if needed. However to do that we need to make vehReg field in Vehicle class, which means we need to pass that as parameter in Vehicle constructor, which means we need to pass individual fields of VehicleRegistration class as parameters in Vehicle constructor, which means we need to modify constructors of all subclasses of Vehicle class to take those individual fields as parameters and pass them to super constructor. This is a bit tedious but it is worth it if we want to avoid all this typecasting in main method
        }
    }
}
//this is where compareto interface is useful since we can now sort an array of Vehicle references (which can point to Car, Bike, Truck objects) based on horsepower
//it allows us to compare object of car with object of truck etc since they all inherit from Vehicle class which implements Comparable interface
//and in its implementation we type cast Object to Vehicle so even though vehicle[j] might be of different subclass type than vehicle[i], we can still compare them based on horsepower since they are both of Vehicle parent class type, and due to polymorphism which allows us to typecast object to Vehicle.