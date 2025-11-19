class Truck extends Vehicle {
    double maximumWeightCapacity;
    double loadedWeight;
    public Truck(String brand, int year, double fuelLeft, double fuelCapacity, double efficiency, double maxSpeed, double horsePower, int noOfPassengers, double maximumWeightCapacity, double loadedWeight) {
        super(brand, year, fuelLeft, fuelCapacity, efficiency, maxSpeed, horsePower, noOfPassengers);
        this.maximumWeightCapacity = maximumWeightCapacity; 
        this.loadedWeight = loadedWeight;
    }
    @Override
    public void printInfo() {
        super.printInfo();
        System.out.println("Maximum Weight Capacity: " +maximumWeightCapacity);
        System.out.println("Loaded Weight: " +loadedWeight);
        System.out.println("Fuel Left: " +getFuelLeft());
        System.out.println("Efficiency: " +getEfficiency());
    }
    public double calculateRange(double currentLoad) {
        return ((1 - (currentLoad / maximumWeightCapacity) * 0.5) * getEfficiency());
    }
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