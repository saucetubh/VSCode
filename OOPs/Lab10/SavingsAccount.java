import java.util.*;

class SavingsAccount{
    // Fields
    public int balance;
    public int interestRate;
    public List<Integer> fixedDeposit;
    public Map <Integer, Integer> interestDetails = new HashMap<>();

    // Constructor: sets balance and fixedDeposit (defensive copy)
    public SavingsAccount(int balance, List<Integer> fixedDeposit) {
        this.balance = balance;
        if (fixedDeposit != null) {
            this.fixedDeposit = new ArrayList<>(fixedDeposit);
        } else {
            this.fixedDeposit = new ArrayList<>();
        }
    }
    // Calculates interest for each fixed deposit and stores it in interestDetails.
    // Uses 1-based keys to match the sample (1 -> first fixed deposit, 2 -> second, ...)
    public void interestCalculation(int interestRate) {
        this.interestRate = interestRate;
        interestDetails.clear();
        for (int i = 0; i < fixedDeposit.size(); i++) {
            int key = i + 1; // 1-based key to match sample
            int amount = fixedDeposit.get(i);
            int interest = interestRate * amount;
            interestDetails.put(key, interest);
        }
    }
} //AI answer


/*
class SavingsAccount{
    public Map <Integer, Integer> interestDetails = new HashMap<>();
    private int balance;
    private int interestRate;
    public List<Integer> fixedDeposit;
    public SavingsAccount(int balance, List<Integer> fixedDeposit) {
        this.balance = balance;
        this.fixedDeposit = fixedDeposit;
    }
    public void interestCalculation(int interestRate) {
        this.interestRate = interestRate;
        int key = 0;
        for(Integer i : fixedDeposit) {
            interestDetails.put(key++, i*interestRate);
        }
    }
} //My Answer
*/