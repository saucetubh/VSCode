public class Bike extends Vehicle {
    boolean isElectric;
    VehicleRegistration vehReg;
    public Bike(String brand, int year, double fuelLeft, double fuelCapacity, double efficiency, double maxSpeed, double horsePower, int noOfPassengers, boolean isElectric, int registrationNo, String chasisNo, String ownerName, int insuranceNo, String insuredUpto, String insurersName) {
        super(brand, year, fuelLeft, fuelCapacity, efficiency, maxSpeed, horsePower, noOfPassengers, insuranceNo, insuredUpto, insurersName);
        this.isElectric = isElectric;
        this.vehReg = new VehicleRegistration(registrationNo, chasisNo, ownerName);
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
    public VehicleRegistration getVehReg() {
        return this.vehReg;
    }
    public void setVehReg(VehicleRegistration vehReg) {
        this.vehReg = vehReg;
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