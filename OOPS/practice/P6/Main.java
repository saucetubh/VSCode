class Shape { //since no modifier means it is package access (default access modifier)
    private int x = 1;
    class TwoD {
        private int x = 2;
        class Circle {
            private int x = 3;
            {System.out.println(Shape.this.x);}
            private int radius;
            public Circle(int radius) {
                this.radius = radius;
            }
        }
        class Square {
            private int side;
            public Square(int side) {
                this.side = side;
            }
        }
        class Rectangle {
            private int length, width;
            public Rectangle(int length, int width) {
                this.length = length;
                this.width = width;
            }
        }
    }
    class ThreeD {
        class Cube {
            private int length;
            public Cube(int length) {
                this.length = length;
            }
        }
    }
}
public class Main{
    public static void main(String[] args) {
        //Shape c = new Shape(); not necessary since 2D class is static
        //Shape.TwoD s1 = new Shape.TwoD(); //necessary since we need a twod class object to create an object using circle class
        /*
        Shape.TwoD.Circle c = s1.new Circle(5);
        Shape.TwoD.Square sq = s1.new Square(6);
        Shape s = new Shape();
        Shape.ThreeD s2 = s.new ThreeD();
        Shape.ThreeD.Cube cu = s2.new Cube(7);
        */
        Shape c = new Shape();
        Shape.TwoD c2 = c.new TwoD();
        Shape.TwoD.Circle c3 = c2.new Circle(5);
    }
}