public class Bike extends Vehicle {
    boolean isElectric;
    public Bike(String brand, int year, double fuelLeft, double fuelCapacity, double efficiency, double maxSpeed, double horsePower, int noOfPassengers, boolean isElectric){
        super(brand, year, fuelLeft, fuelCapacity, efficiency, maxSpeed, horsePower, noOfPassengers);
        this.isElectric = isElectric;
    }
    @Override
    public void printInfo() {
        super.printInfo();
        System.out.println("Is Electric: " +isElectric);
        System.out.println("Fuel Left: " + getFuelLeft());
        System.out.println("Efficiency: " + getEfficiency());
    }
    @Override
    public double calculateRange() {
        if(isElectric) {
            return (1.5*getFuelLeft()*getEfficiency());
        }
        else {
            return getFuelLeft()*getEfficiency();
        }
    }
    public void honk() {
        System.out.println("Honk");
    }
    public boolean getIsElectric() {
        return this.isElectric;
    }
    public void setIsElectric(boolean isElectric) {
        this.isElectric = isElectric;
    }
    @Override
    public double compareTo(Object other) {
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
typeOfCar
isElectric
*/