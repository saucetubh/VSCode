public class Circle extends Shape {
    private final double radius;
    private final double PI = 3.14;
    public Circle(double radius, String color, String size) {
        super(color, size);
        this.radius = radius;
    }
    @Override
    double calculateArea() {
        return PI * radius * radius;
    }
    {
        //System.out.println("Area of circle: " + this.calculateArea()); //this will output 0 not the actual area. idk why
        System.out.println("Color of circle: " + super.getAppearance().getColor());
        System.out.println("Size of circle: " + super.getAppearance().getSize());
    }
}