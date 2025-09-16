class SavingsAccount extends Account {
  private static final double INTEREST_RATE = 0.02;

  public SavingsAccount(String accountNumber, double initialBalance) {
    super(accountNumber, initialBalance);
  }

  // Overriding the `deposit` method to calculate and add interest.
  @Override
  public void deposit(double amount) {
    // Call the parent class's deposit method.
    super.deposit(amount);
    // Calculate and add interest to the balance.
    double interest = amount * INTEREST_RATE;
    balance += interest;
    System.out.println("Interest of $" + String.format("%.2f", interest) + " was added to your account.");
  }
}