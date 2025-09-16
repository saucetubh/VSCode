class CheckingAccount extends Account {
  private static final double TRANSACTION_FEE = 1.50;

  public CheckingAccount(String accountNumber, double initialBalance) {
    super(accountNumber, initialBalance);
  }

  // Overriding the `withdraw` method to apply a transaction fee.
  @Override
  public void withdraw(double amount) {
    // We call the parent class's withdraw method first.
    double totalWithdrawal = amount + TRANSACTION_FEE;
    if (totalWithdrawal <= balance) {
      super.withdraw(totalWithdrawal);
      System.out.println("A transaction fee of $" + String.format("%.2f", TRANSACTION_FEE) + " was applied.");
    } else {
      System.out.println("Withdrawal failed due to insufficient funds (including fee).");
    }
  }
}