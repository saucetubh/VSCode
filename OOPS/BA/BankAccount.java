public class BankAccount {
    private final String name;
    private double balance;
    public BankAccount(String name, double balance) {
        this.name = name;
        this.balance = balance;
    }
    static class Validator {
        public static boolean isValid(BankAccount acc, double amt) {
            return ((amt <= acc.balance) && (amt > 0)) ;
        }
    }
    public void withdraw(double amt) {
        if(Validator.isValid(this, amt)) {
            this.balance = this.balance - amt;
            System.out.println("Balance: " + this.balance);
        }
        else System.out.println("INVALID");
    }
    public void deposit(double amt) {
        if(amt<=0) System.out.println("INVALID");
        else {
            this.balance = this.balance + amt;
            System.out.println("Balance: " + this.balance);
        }
    }
}