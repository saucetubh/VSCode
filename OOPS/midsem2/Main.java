/*
class SavingsAccount {
    public int balance, interest, taxSlab;
    public TaxSetup ts;
    public SavingsAccount(int balance, int interest, int taxSlab) {
        this.balance=balance;
        this.interest=interest;
        this.taxSlab=taxSlab;
    }
    static class TaxSetup {
        public int taxPay;
        public TaxSetup(int interest, int taxSlab) {
            this.taxPay = interest*taxSlab;
        }
    }
    public void taxCalculation(int interest, int taxSlab) {
        this.ts = new SavingsAccount.TaxSetup(interest, taxSlab);
    }
}

public class Main {
    public static void main(String[] args) {
        SavingsAccount sa1 = new SavingsAccount(100, 10, 2);
        sa1.taxCalculation(10, 2);
        System.out.println(sa1.ts.taxPay);
    }
}
*/
//alternate variants 
//with non static inner class
/*
class SavingsAccount {
    public int balance, interest, taxSlab;
    public TaxSetup ts;
    public SavingsAccount(int balance, int interest, int taxSlab) {
        this.balance=balance;
        this.interest=interest;
        this.taxSlab=taxSlab;
    }
    class TaxSetup {
        public int taxPay;
        public TaxSetup() {
            this.taxPay = (SavingsAccount.this.interest * SavingsAccount.this.taxSlab);
        }
    }
    public void taxCalculation() {
        this.ts = this.new TaxSetup();
    }
}

public class Main {
    public static void main(String[] args) {
        SavingsAccount sa1 = new SavingsAccount(100, 10, 2);
        sa1.taxCalculation();
        System.out.println(sa1.ts.taxPay);
    }
}
*/
//with static inner class (slightly diff)
class SavingsAccount {
    public int balance, interest, taxSlab;
    public TaxSetup ts;
    public SavingsAccount(int balance, int interest, int taxSlab) {
        this.balance=balance;
        this.interest=interest;
        this.taxSlab=taxSlab;
    }
    static class TaxSetup {
        public int taxPay;
        public TaxSetup(SavingsAccount sa) {
            this.taxPay = sa.interest * sa.taxSlab;
        }
    }
    public void taxCalculation() {
        this.ts = new SavingsAccount.TaxSetup(this);
    }
}

public class Main {
    public static void main(String[] args) {
        SavingsAccount sa1 = new SavingsAccount(100, 10, 2);
        sa1.taxCalculation();
        System.out.println(sa1.ts.taxPay);
    }
}