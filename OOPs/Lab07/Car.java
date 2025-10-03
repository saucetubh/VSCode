public class Car extends Vehicle {
    private String typeOfCar;
    private VehicleRegistration vehReg;
    public Car(String brand, int year, double fuelLeft, double fuelCapacity, double efficiency, double maxSpeed, double horsePower, int noOfPassengers, String typeOfCar, /*VehicleRegistration vehReg?*/int registrationNo, String chasisNo, String ownerName) {
        super(brand, year, fuelLeft, fuelCapacity, efficiency, maxSpeed, horsePower, noOfPassengers);
        this.typeOfCar = typeOfCar;
        this.vehReg = new VehicleRegistration(registrationNo, chasisNo, ownerName);
    }
    @Override //overrides the method that directly follows it, not all the methods after it. It's a good practice to use override even though this method would automatically be overridden
    public void printInfo() {
        super.printInfo(); //calls the printInfo method from Vehicle (parent class)
        System.out.println("Type of Car: " + typeOfCar); //this doesnt show error because this variable was declared in this class
        System.out.println("No of passengers: " + getNoOfPassengers()); //using getter method from Vehicle class, because the variables in Vehicle class are private, so they cannot be accessed directly
        System.out.println("Fuel Left: " + getFuelLeft()); //alternate method would be to change the access modifier of the variable in Vehicle class to protected or default (so that it can be accessed in the subclass) but using getter methods is a better practice
        System.out.println("Efficiency: " + getEfficiency());
    }
    public void Honk() {
        System.out.println("Honk");
    }
    public String getTypeOfCar() {
        return this.typeOfCar;
    }
    public void setTypeOfCar(String typeOfCar) {
        this.typeOfCar = typeOfCar;
    }
    @Override //implementing the abstract method of the abstract class in its concrete subclass
    public double calculateRange() {
        return getFuelLeft()*getEfficiency();
    }
    @Override
    public double compareTo(Object other) {
        Vehicle otherV = (Vehicle) other;
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
*/