package geometry.two;
public class Circle implements myComparable{
    private int radius;
    public Circle(int radius) {
        this.radius = radius;
    }
    public int getRadius() {
        return radius;
    }
    public void setRadius(int radius) {
        this.radius = radius;
    }
    @Override 
    public int compareTo(Object other) {
        Circle c = (Circle) other;
        return this.radius - c.radius;
    }
}


//radius is private and cannot be accessed outside the class directly