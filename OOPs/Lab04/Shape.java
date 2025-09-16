public abstract class Shape {
    protected String color;

    public Shape(String color) {
        this.color = color;
    }

    public String getColor() {
        return color;
    }

    public abstract double area();

    public abstract double perimeter();

    public void displayInfo() {
        System.out.println("Shape Info:");
        System.out.println("Color: " + this.color);
        System.out.printf("Area: %.2f\n", this.area());
        System.out.printf("Perimeter: %.2f\n", this.perimeter());
    }
}
