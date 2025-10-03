public class Truck extends Vehicle {
    double maximumWeightCapacity;
    double loadedWeight;
    VehicleRegistration vehReg; //composition - Truck "has a" VehicleRegistration. nested class VehicleRegistration is used here as a field
    public Truck(String brand, int year, double fuelLeft, double fuelCapacity, double efficiency, double maxSpeed, double horsePower, int noOfPassengers, double maximumWeightCapacity, double loadedWeight, VehicleRegistration vehReg) {
        super(brand, year, fuelLeft, fuelCapacity, efficiency, maxSpeed, horsePower, noOfPassengers);
        this.maximumWeightCapacity = maximumWeightCapacity; 
        this.loadedWeight = loadedWeight;
        this.vehReg = vehReg; //differenc in how i am doing this in Truck and Car class, because in Truck class, i am passing the object of VehicleRegistration class as parameter, whereas in Car class, i am passing the individual fields and creating the object of VehicleRegistration class inside the constructor of Car class
    } //what difference does it make? In Truck class, i can create the object of VehicleRegistration class in main method and pass it to Truck constructor, whereas in Car class, i cannot create the object of VehicleRegistration class in main method, because it is a nested class inside Vehicle class, so i have to create the object of VehicleRegistration class inside the constructor of Car class
    @Override
    public void printInfo() {
        super.printInfo();
        System.out.println("Maximum Weight Capacity: " +maximumWeightCapacity);
        System.out.println("Loaded Weight: " +loadedWeight);
        System.out.println("Fuel Left: " +getFuelLeft());
        System.out.println("Efficiency: " +getEfficiency());
    }
    @Override
    public double calculateRange() {
        return ((1 - (loadedWeight / maximumWeightCapacity) * 0.5) * getEfficiency());
    } //ovverriding abstract method of Vehicle class
    public double calculateRange(double currentLoad) {
        return ((1 - (currentLoad / maximumWeightCapacity) * 0.5) * getEfficiency());
    } //overloaded method
    public void Honk() {
        System.out.println("Honk");
    }
    public double getMaximumWeightCapacity() {
        return this.maximumWeightCapacity;
    }
    public double getLoadedWeight() {
        return this.loadedWeight;
    }
    public void setMaximumWeightCapacity(double maximumWeightCapacity) {
        this.maximumWeightCapacity = maximumWeightCapacity;
    }
    public void setLoadedWeight(double loadedWeight) {
        this.loadedWeight = loadedWeight;
    }
    public VehicleRegistration getVehReg() {
        return this.vehReg;
    }
    public void setVehReg(VehicleRegistration vehReg) {
        this.vehReg = vehReg;
    }
    @Override
    public double compareTo(Object other) { //must use Object as parameter type to correctly implement Comparable interface
        //Truck otherTruck = (Truck) other; //type casting Object to Truck //this will throw ClassCastException when in my main, i compare Truck object with Car or Bike object
        Vehicle otherV = (Vehicle) other; //type casting Object to Vehicle
        return this.getHorsePower() - otherV.getHorsePower();
    }
    
}

/*
Order of Fields in the constructor

brand
year
fuelLeft
fuelCapacity
efficiency
maxSpeed
horsePower
noOfPassengers
maximumWeightCapacity
loadedWeight
*/