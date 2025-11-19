public class BankAccount {
    public enum Currency {
        INR, USD
    }

    // Instance attributes
    private Currency currencyType;
    private String accountNumber;
    private String accountHolder;
    private double currentAmount;

    // One static exchange rate (1 USD = 87 INR)
    public static final double USD_TO_INR = 87.0;

    // Constructor
    public BankAccount(String accountNumber, String accountHolder, Currency currencyType, double initialAmount) {
    }

    // Convert given amount into INR
    public static double usdToINR(double amount) {
    }

    // Convert given amount into USD
    public static double inrToUSD(double amount) {
    }

    // Transfer money between accounts (with currency conversion if needed)
    public boolean transaction(BankAccount toAccount, double amount) {
    }

    // Deposit money of same currency as This account
    public boolean deposit(double amount) {
    }

    // Deposit money of different Currency
    public boolean deposit(double amount, Currency currencyType) {
    }

    // Implement getters and setters

}
