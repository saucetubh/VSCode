interface Comparable {
    double compareTo(Object o);
}
abstract class Vehicle implements Comparable {
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
    } //abstract class does not need a constructor, but can have one, since in previous problem -lab02, we used it hence we will still use it here

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

    public abstract double calculateRange();
    
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
    public static class VehicleRegistration { //public static is necessary here, otherwise gives yellow squiggle -> with static, we can create object of this nested class in main method without creating object of outer class Vehicle
        private int registrationNo;
        private String chasisNo; //if you get warning here that field can be final, never used, means that its never being modified after initialization, so you can either make it final, or make setter method for it and get rid of warning
        private String ownerName;
        public VehicleRegistration(int registrationNo, String chasisNo, String ownerName) {
            this.registrationNo = registrationNo;
            this.chasisNo = chasisNo;
            this.ownerName = ownerName;
        }
        public int getRegistrationNo() {
            return this.registrationNo;
        }

        public String getChasisNo() {
            return this.chasisNo;
        }

        public String getOwnerName() {
            return this.ownerName;
        }
        public void setRegistrationNo(int registrationNo) {
            this.registrationNo = registrationNo;
        }
        public void setChasisNo(String chasisNo) {
            this.chasisNo = chasisNo;
        }
        public void setOwnerName(String ownerName) {
            this.ownerName = ownerName;
        }
    } //nested class. The outer class can have an object of the nested class as its field, and used in its constructor
}//depending on your use, nested class can be static or non-static. If it is static, we can create object of this nested class in main method without creating object of outer class Vehicle. If it is non-static, we need to create object of outer class Vehicle first, then only we can create object of this nested class VehicleRegistration
//static nested class cannot access non-static members of outer class directly, but non-static nested class can access all members of outer class directly, i.e even the private fields

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

