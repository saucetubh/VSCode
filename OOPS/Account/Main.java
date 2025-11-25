public class Main {
    public static void main(String[] args) {
        Account a = new Account(2000, 0.05);
        //Account.TaxCalculator t = a.new TaxCalculator();
        System.out.println(a.new TaxCalculator().computeTax());
    }
}