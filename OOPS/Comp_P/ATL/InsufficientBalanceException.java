public class InsufficientBalanceException extends Exception {
    public InsufficientBalanceException(int amt) {
        super("You do not have sufficient funds to withdraw "+amt);
    }
}