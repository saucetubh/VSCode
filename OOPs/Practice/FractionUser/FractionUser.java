class Fraction {
    int num, denom; 
    public Fraction(int n, int d) {
        num = n;
        denom = d;
    }
    public int getNum() {
        return num;
    }
    public int getDenom() {
        return denom;
    }
    public Fraction add(Fraction F) {
        int n1 = this.num * F.denom + F.num * this.denom;
        int d1 = this.denom * F.denom;
        return new Fraction(n1, d1);
    } 
    public Fraction subtract(Fraction F) {
        int n1 = this.num * F.denom - F.num * this.denom;
        int d1 = this.denom * F.denom;
        return new Fraction(n1, d1);
    }
    public Fraction multiply(Fraction F) {
        int n1 = this.num * F.num;
        int d1 = this.denom * F.denom;
        return new Fraction(n1, d1);
    }
    public Fraction divide(Fraction F) {
        int n1 = this.num * F.denom;
        int d1 = this.denom * F.num;
        return new Fraction(n1, d1);
    }
}

public class FractionUser {
    public static void main(String[] args) {
        Fraction f1 = new Fraction(1, 2); 
        Fraction f2 = new Fraction(3, 4);
        Fraction f3 = new Fraction(5, 6);
        Fraction f4 = new Fraction(7, 8);
        Fraction sum = f1.add(f2);
        Fraction difference = f1.subtract(f2);
        Fraction product = f3.multiply(f4);
        Fraction quotient = f3.divide(f4);
        System.out.println("f1 + f2: " + sum.getNum() + "/" + sum.getDenom());
        System.out.println("f1 - f2: " + difference.getNum() + "/" + difference.getDenom());
        System.out.println("f3 * f4: " + product.getNum() + "/" + product.getDenom());
        System.out.println("f3 / f4: " + quotient.getNum() + "/" + quotient.getDenom());
    }
}

//this time the methods were not static, so we needed to create an object to call them
//thus when using the add method, we only need one argument which is the second fraction
//the first fraction is the object that add will be called using, and to implement that we use the 'this' keyword