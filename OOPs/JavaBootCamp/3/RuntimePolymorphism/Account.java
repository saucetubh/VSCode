class Account {
  // Protected instance variables so subclasses can access them directly.
  protected String accountNumber;
  protected double balance;

  // Constructor to initialize an account.
  public Account(String accountNumber, double initialBalance) {
    this.accountNumber = accountNumber;
    this.balance = initialBalance;
    System.out.println("New Account created with number: " + accountNumber);
  }

  // A method to deposit money into the account. This can be overridden.
  public void deposit(double amount) {
    if (amount > 0) {
      balance += amount;
      System.out.println("Deposit of $" + amount + " successful.");
    } else {
      System.out.println("Deposit amount must be positive.");
    }
  }

  // A method to withdraw money from the account. This will be overridden.
  public void withdraw(double amount) {
    if (amount > 0 && amount <= balance) {
      balance -= amount;
      System.out.println("Withdrawal of $" + amount + " successful.");
    } else if (amount > balance) {
      System.out.println("Insufficient funds for this withdrawal.");
    } else {
      System.out.println("Withdrawal amount must be positive.");
    }
  }

  // A method to get the current balance.
  public double getBalance() {
    return balance;
  }

  // A method to display account details.
  public void displayAccountInfo() {
    System.out.println("Account Number: " + accountNumber);
    System.out.println("Current Balance: $" + String.format("%.2f", balance));
  }
}