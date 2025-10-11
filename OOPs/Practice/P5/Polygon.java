interface Side {
    boolean compareSides(Object other);
}
public class Polygon extends Shape implements Side {
    private final double sides, sideLength, apothem;
    public Polygon(String color, String size, double sides, double sideLength, double apothem) {
        super(color, size);
        this.sides = sides;
        this.sideLength = sideLength;
        this.apothem = apothem;
    }
    @Override 
    public double calculateArea() {
        class Perimeter { //local class
            double getPerimeter() {
                return sides * sideLength;
            }
        }
    Perimeter p = new Perimeter();
    return (p.getPerimeter() * apothem) / 2;
    }
    @Override 
    public boolean compareSides(Object other) {
        Polygon p1 = (Polygon) other;
        return (this.sides == p1.sides);
    }
    static {
        System.out.println("Polygon class loaded");
    }
}