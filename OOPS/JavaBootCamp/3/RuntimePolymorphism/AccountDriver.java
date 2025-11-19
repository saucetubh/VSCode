public class AccountDriver {
  public static void main(String[] args) {
    // Create an array of Account objects. This array can hold
    // objects of its subclasses, demonstrating polymorphism.
    Account[] accounts = new Account[2];
    accounts[0] = new CheckingAccount("C1001", 500.00); //if you wrote accounts[0] = new Account("C1001", 500.00); it would use the method of the Account class since you assigned it the instance of the Account class
    //why is it better to use CheckingAccount instead of Account? 
    accounts[1] = new SavingsAccount("S2001", 1000.00);
    System.out.println("\n--- Performing operations on the Checking Account ---");
    // We treat the CheckingAccount object as a generic Account.
    accounts[0].displayAccountInfo();
    accounts[0].deposit(100.00);
    accounts[0].displayAccountInfo();
    accounts[0].withdraw(50.00);  //used the withdraw method from CheckingAccount
    accounts[0].displayAccountInfo();

    System.out.println("\n--- Performing operations on the Savings Account ---");
    // We treat the SavingsAccount object as a generic Account.
    accounts[1].displayAccountInfo();
    accounts[1].deposit(200.00);
    accounts[1].displayAccountInfo();
    accounts[1].withdraw(150.00); //used the withdraw method from SavingsAccount
    accounts[1].displayAccountInfo();
  }
}
//the way we used to typecase in C when dividing integers into doubles
//similarly we can typecast objects in Java.
