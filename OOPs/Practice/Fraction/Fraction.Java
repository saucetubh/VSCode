public class Fraction {
    private int num, denom; //this is the field
    public Fraction(int n, int d) {
        num = n;
        denom = d;
    } //this was the constructor, it's used to initialize the fraction
    public static void main(String[] args) {
        Fraction f1 = new Fraction(1, 2); //this is an object of the Fraction class type
        Fraction f2 = new Fraction(3, 4);
        System.out.println("Fraction 1: " + f1.getNumerator() + "/" + f1.getDenominator());
        System.out.println("Fraction 2: " + f2.getNumerator() + "/" + f2.getDenominator());
        System.out.println("Sum: " + FractionOperation.add(f1, f2).getNumerator() + "/" + FractionOperation.add(f1, f2).getDenominator());
        System.out.println("Decimal of Fraction 1: " + FractionOperation.getDecimal(f1));
        System.out.println("Decimal of Fraction 2: " + FractionOperation.getDecimal(f2));
    } //this is the main method, this gets executed
    public int getNumerator() {
        return num;
    } 
    public int getDenominator() {
        return denom;
    } //these are methods that can be called in the main method
}
class FractionOperation {
    public static Fraction add(Fraction F1, Fraction F2) {
        int numerator = F1.getNumerator() * F2.getDenominator() + F2.getNumerator() * F1.getDenominator();
        int denominator = F1.getDenominator() * F2.getDenominator();
        return new Fraction(numerator, denominator);
    } //method to add fractions
    public static float getDecimal(Fraction F) {
        return (float) F.getNumerator() / (float) F.getDenominator();
    } //method to convert them to decimal
}
//private and public are access modifiers in Java
//private means that the field or method can only be accessed within the class itself
//public means that the field or method can be accessed from outside the class
//static indicates that the field or method belongs to the class itself rather than to instances of the class
//in simpler words, to access the method we wont have to create an object like we did f1.getNumerator(); where f1 is an object we made
//we can call the method directly using the class name, like FractionOperation.add(); because it is a static method