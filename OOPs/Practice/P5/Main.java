public class Main {
    public static void main(String[] args) {
        Shape c1 = new Circle(5, "Red", "Small");
        Shape p1 = new Polygon("Blue", "Big", 4, 5, 6); //IGNORE THE ACCURACY OF THE CALCULATEAREA METHOD
        //System.out.println("Area of polygon: "+p1.calculateArea()); //calculateArea() method of Shape class called, since p1 has reference of Shape class
        //System.out.println("Area of circle: "+c1.calculateArea());
        Polygon p2 = new Polygon("Green", "Small", 6, 3, 4);
        Circle c2 = new Circle(7, "Yellow", "Big");
        Shape[] shapes = {c1, p1, p2, c2};
        for(Shape s: shapes) {
            System.out.println("Area: "+s.calculateArea());
        }
        for(int i=0; i<shapes.length; i++) {
            for(int j=i+1; j<shapes.length; j++) {
                if(shapes[i].compareArea(shapes[j])) {
                    System.out.println("Shape "+(i+1)+" and Shape "+(j+1)+" have same area.");
                } else {
                    System.out.println("Shape "+(i+1)+" and Shape "+(j+1)+" have different areas.");
                }
                if(shapes[i] instanceof Polygon && shapes[j] instanceof Polygon) {
                    Polygon poly1 = (Polygon) shapes[i];
                    Polygon poly2 = (Polygon) shapes[j];
                    if(poly1.compareSides(poly2)) {
                        System.out.println("Polygon "+(i+1)+" and Polygon "+(j+1)+" have same number of sides.");
                    } else {
                        System.out.println("Polygon "+(i+1)+" and Polygon "+(j+1)+" have different number of sides.");
                    }
                }
            }
        }
    }

}