class Fraction {
    private int num, denom;
    public Fraction() {
        num = 0;
        denom = 1;
    }
    public Fraction(int n) {
        num = n;
        denom = 1;
    }
    public Fraction(int n, int d) {
        num = n;
        denom = d;
    }
    public int getNum() {
        return this.num;
    }
    public int getDenom() {
        return this.denom;
    }
    public Fraction add(Fraction F) {
        int n1 = (this.num * F.denom) + (this.denom * F.num);
        int d1 = this.denom * F.denom;
        return new Fraction(n1, d1);
    }
    public void Reduce() {
        int a = Math.max(this.num, this.denom);
        int b = Math.min(this.num, this.denom);
        int gcd = gcd(a,b);
        this.num = num/gcd;
        this.denom = denom/gcd;
    }
    public static int gcd(int a, int b) { //using the Euclidean Algorithm
        int gcd = b;
        while (a%b != 0) {
            gcd = a%b;
            a = b;
            b = gcd;
        }
        return gcd;
    }
}

public class FractionUser {
    public static void main(String[] args) {
        Fraction f1 = new Fraction(1,8);
        Fraction f2 = new Fraction(4,8);
        Fraction f3 = f1.add(f2);
        f3.Reduce();
        //System.out.println("f3 = " + f3.num + "/" + f3.denom ); //this wont work since num and denom are private to the class, so cannot be accessed outside it
        System.out.println("f3 = " + f3.getNum() + "/" + f3.getDenom());
        Fraction[] fractions = {f1, f2, f3};
        int maxNum = Math.max(Math.max(fractions[0].getNum(), fractions[1].getNum()), fractions[2].getNum()); //Math.max only works with 2 numbers at a time
        System.out.println("Max Numerator is: " +maxNum);
    }
}


