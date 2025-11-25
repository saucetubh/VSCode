public class Main {
    public static void main(String[] args) {
        BankAccount acc = new BankAccount("John", 1000.0);
        BankAccount acc2 = new BankAccount("Doe", 500.0);
        acc.deposit(200.0);  // Balance: 1200.0
        acc.withdraw(300.0); // Balance: 900.0
        acc.withdraw(1000.0); // INVALID
        acc2.deposit(-50.0); // INVALID
        acc2.withdraw(100.0); // Balance: 400.0
    }
}