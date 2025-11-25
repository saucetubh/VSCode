public class Account {
    private double balance, interestRate;
    public Account(double balance, double interestRate) {
        this.balance = balance;
        this.interestRate = interestRate;
    }
    public static class Extractor {
        public static double getBalance(Account a) {return a.balance;}
        public static double getInterest(Account a) {return a.interestRate;}
    }
    class TaxCalculator { //non static inner class cannot have any static fields or methods
        public double computeTax() {
            return Account.Extractor.getBalance(Account.this) * Account.Extractor.getInterest(Account.this);
        }
    }
}
