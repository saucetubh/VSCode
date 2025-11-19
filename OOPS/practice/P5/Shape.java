interface Area {
    boolean compareArea(Object other);
}
abstract class Shape implements Area {
    public class Looks{
        private String color;
        private String size; //big or small
        public Looks(String color, String size) {
            this.color = color;
            this.size = size;
        }
        public String getColor() {
            return color;
        }
        public String getSize() {
            return size;
        }
        public void setColor(String color) {
            this.color = color;
        }
        public void setSize(String size) {
            this.size = size;
        }
    }
    public Looks getAppearance() {
        return appearance;
    }
    private final Looks appearance; //since no setter methods made, make it final
    public Shape(String color, String size) {
        this.appearance = new Looks(color, size);
    }
    abstract double calculateArea();
    @Override 
    public boolean compareArea(Object other) {
        Shape c1 = (Shape) other; //c1 is a local variable of type Shape since it was created inside a method
        return (this.calculateArea() == c1.calculateArea());
    }
}