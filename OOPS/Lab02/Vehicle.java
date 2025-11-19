class Vehicle {
    private String brand; 
    private int year; 
    private double fuelLeft; 
    private double fuelCapacity; 
    private double efficiency; 
    private double maxSpeed; 
    private double horsePower; 
    private int noOfPassengers; 

    public Vehicle(String brand, int year, double fuelLeft, double fuelCapacity, double efficiency, double maxSpeed, double horsePower, int noOfPassengers){
        this.brand = brand;
        this.year = year;
        this.fuelLeft = fuelLeft;
        this.fuelCapacity = fuelCapacity;
        this.efficiency = efficiency;
        this.maxSpeed = maxSpeed;
        this.horsePower = horsePower;
        this.noOfPassengers = noOfPassengers;
    }

    public String getBrand() {
        return this.brand; //is there a difference between using this.brand or just brand?
    }
    public int getYear() {
        return this.year;
    }
    public double getFuelLeft() {
        return this.fuelLeft;
    }

    public double getFuelCapacity() {
        return this.fuelCapacity;
    }

    public double getEfficiency() {
        return this.efficiency;
    }

    public double getMaxSpeed() {
        return this.maxSpeed;
    }

    public double getHorsePower() {
        return this.horsePower;
    }

    public int getNoOfPassengers() {
        return this.noOfPassengers;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }
    public void setYear(int year) {
        this.year = year;
    }
    public void setFuelLeft(double fuelLeft) {
        this.fuelLeft = fuelLeft;
    }

    public void setFuelCapacity(double fuelCapacity) {
        this.fuelCapacity = fuelCapacity;
    }

    public void setEfficiency(double efficiency) {
        this.efficiency = efficiency;
    }

    public void setMaxSpeed(double maxSpeed) {
        this.maxSpeed = maxSpeed;
    }

    public void setHorsePower(double horsePower) {
        this.horsePower = horsePower;
    }

    public void setNoOfPassengers(int noOfPassengers) {
        this.noOfPassengers = noOfPassengers;
    }

    public double calculateRange() {
        return (fuelLeft * efficiency); 
    }
    
    public void printInfo() {
        System.out.println("Brand: " + brand);
        System.out.println("Year: " + year);
        System.out.println("Max Speed: " + maxSpeed);
        System.out.println("Horse Power: " + horsePower);
    }
    public void printInfo(String driverName) {
        System.out.println("Driver Name: " + driverName);
        System.out.println("Brand: " + brand);
        System.out.println("Year: " + year);
        System.out.println("Max Speed: " + maxSpeed);
        System.out.println("Horse Power: " + horsePower);
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
*/

