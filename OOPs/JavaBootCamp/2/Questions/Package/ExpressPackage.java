/*
    TODO:
    Implement the ExpressPackage class.
    Refer to the Main class to understand its usage.
*/
class ExpressPackage extends Package {
    private double expressFee;
    public ExpressPackage(int id, double weight, double expressFee) {
        super(id, weight); // Call the constructor of the Package class
        this.expressFee = expressFee;
    }
//since calculate cost for this is different, we need to override the method in package class 
@Override 
public double calculateCost(double ratePerKg) {
    return super.calculateCost(ratePerKg) + expressFee; //super refers to the parent class, so it called the method from Package class, gets the cost and adds expressfee for new cost
}
}