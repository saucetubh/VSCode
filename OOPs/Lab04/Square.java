public class Square extends Rectangle {
    protected double side; //protected package implies accessible within package and subclasses

    public Square(String color, double side) {
        super(color, side, side); // Initialize length and width of Rectangle
        if (side <= 0) {
            throw new IllegalArgumentException("Side must be a positive value.");
        }
        this.side = side;
    }

    // Methods are inherited from Rectangle, no need to override
}