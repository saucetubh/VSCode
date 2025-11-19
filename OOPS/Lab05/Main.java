public class Main {
    public static void main(String[] args) {
        Shape circle = new Circle("Red", 5.0); //normally this wont be able to use methods in the Circle class since it is a Shape reference but here it can because Shape is an abstract class and it has the abstract method defined in the class
        Shape ellipse = new Ellipse("Black", 5.2, 3.4);
        Shape rectangle = new Rectangle("Blue", 12, 13);
        Shape square = new Square("Green", 3.5);
        Shape[] shapeList = new Shape[]{circle, ellipse, rectangle, square};
        for(int i=0; i<4; i++) {
            shapeList[i].displayInfo();
        }
    }
}