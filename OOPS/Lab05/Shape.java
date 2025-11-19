public abstract class Shape {
    String color;
    public Shape(String color) {
        this.color = color;
    }
    public abstract double calculateArea();
    public abstract double calculatePerimeter();
    public void displayInfo() {
        System.out.println("Color: " +color);
        System.out.println("Area: " +calculateArea());
        System.out.println("Perimeter: "+calculatePerimeter());
    }
}