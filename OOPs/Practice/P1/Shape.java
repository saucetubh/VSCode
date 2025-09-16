public class Shape {
    private float area, perimeter;
        public Shape (float area, float perimeter ) {
        this.area = area;
        this.perimeter = perimeter;
    }
    public float getArea() {
        return this.area;
    } 
    public void setArea(Rectangle r) {
        this.area = r.length * r.width; //since we didnt use private modifier on the length and width variables, they are accessible here [package private access]
    }
    public void setArea(Circle c) {
        this.area = (float)(Math.PI * Math.pow(c.radius, 2));
    }
    public void setPerimeter(Circle c) {
        this.perimeter = (float)(2 * Math.PI * c.radius); //float typecasting is necessary because Math uses double
    }
    public float getPerimeter() {
        return this.perimeter;
    } 
    public void setPerimeter(Rectangle r) {
        this.perimeter = 2*(r.length+r.width);   
    }
    //UNDERSTAND WHY YOU ARE GETTING THE YELLOW WARNINGS 
    public static void main(String[] args) {
        Rectangle r1 = new Rectangle(5,3);
        r1.setArea();
        r1.setPerimeter();
        System.out.println("Area: " + r1.getArea());
        System.out.println("Perimeter: " + r1.getPerimeter());
        Circle c1 = new Circle(3);
        System.out.println("Area of Circle: " + c1.getArea());
        System.out.println("Perimeter of Circle: " + c1.getPerimeter());
    }
}


class Rectangle extends Shape{
    float length, width;
    public Rectangle (float len, float wid) {
        super(0,0); //this basically calls the constructor of the parent class Shape with initial values as 0,0
        length = len;
        width = wid;
        //super.setArea(this); //using super means we are calling the parent class's setArea method
        //setPerimeter(this); 
    }
    public void setArea() {
        super.setArea(this);
    }
    public void setPerimeter() {
        setPerimeter(this); //works with and without super -- why? 
    }
}

class Circle extends Shape {
    float radius;
    public Circle (float rad) {
        super(0,0);
        radius = rad;
        super.setArea(this);
        super.setPerimeter(this);
    }
}


