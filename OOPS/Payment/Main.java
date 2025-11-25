interface Payment {
    float pay(float amt);
}

class CardPayment implements Payment {
    @Override 
    public float pay(float amt) {
        return (1.015F*amt);
    }
}

class UPIPayment implements Payment {
    @Override
    public float pay(float amt) {
        return amt;
    }
}

public class Main {
    public static void main(String[] args) {
        Payment p = new CardPayment();
        System.out.println(p.pay(100));
        p = new UPIPayment();
        System.out.println(p.pay(100));
    }
}