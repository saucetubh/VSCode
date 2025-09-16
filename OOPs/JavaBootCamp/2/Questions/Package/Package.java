public class Package {
    private double weight;
    private int id;   // Unique identifier for every package.

    public Package(int id, double weight) {
        this.id = id;
        this.weight = weight;
    }

    public double getWeight() {
        return this.weight;
    }

    // Overloaded methods:
    public double calculateCost(double ratePerKg) {
        return ratePerKg * this.weight;
    }

    public double calculateCost(double ratePerKg, double insuranceFee) {
        return ratePerKg * this.weight + insuranceFee;
    }

    // Method that should NOT be overridden:
    public int getID() {
        return this.id;
    }
}
