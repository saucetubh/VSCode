public class Account {
    private final int ID;
    private int balance;
    public Account(int id, int initialBalance) {
        this.ID = id;
        this.balance = initialBalance;
    }
    public int getId() {
        return this.ID;
    }
    public int getBalance() {
        return this.balance;
    }
    public void applyTransaction(int amt) throws InsufficientBalanceException {
        if(this.balance + amt < 0) throw new InsufficientBalanceException(amt);
        else {
            this.balance = balance + amt;
        }
    }
}