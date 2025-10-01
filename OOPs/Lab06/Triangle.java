public class Triangle { 
    private Point point1, point2, point3; 
    public Triangle(int x1, int x2, int x3, int y1, int y2, int y3){ 
        this.point1 = new Point(x1, y1);
        this.point2 = new Point(x2, y2);
        this.point3 = new Point(x3, y3);
    } 
    public Triangle(Point point1, Point point2, Point point3){ 
        this.point1 = point1;
        this.point2 = point2;
        this.point3 = point3;
    } 
    public Point getPoint1() {
        return point1;
    }
    public Point getPoint2() {
        return point2;
    }
    public Point getPoint3() {
        return point3;
    }
    public void setPoint1(Point p) {
        this.point1 = p;
    }
    public void setPoint2(Point p) {
        this.point2 = p;
    }
    public void setPoint3(Point p) {
        this.point3 = p;
    }   
    public boolean isIsosceles() {
        return !(this.isEquilateral() || this.isScalene()); 
    } 
    public boolean isEquilateral() {
        return (point1.getDistance(point2) == point1.getDistance(point3)) && (point1.getDistance(point2) == point2.getDistance(point3));
    }  
    public boolean isCollinear() {
        return (this.getArea() == 0.0); 
    }
    public double getArea() {
        double a = point1.getDistance(point2); //these are local variables declared within a method hence no access modifier
        double b = point2.getDistance(point3); //access modifiers are given only to class members like fields and methods
        double c = point3.getDistance(point1);
        double s = (a+b+c)/2; //if supposed a,b,c were declared and stored as int, then doing double s = (a+b+c)/2 would give int answer and store as double, i.e if result was 5/2, it will do s=2.0, not 2.5. Then we would have to explicitly type cast or make sure atleast one operand is double, eg double s = (a+b+c)/2.0
        return Math.sqrt(s*(s-a)*(s-b)*(s-c)); 
    }
    public boolean isScalene() {
        return (point1.getDistance(point2) != point1.getDistance(point3)) && (point1.getDistance(point2) != point2.getDistance(point3)) && (point1.getDistance(point3) != point2.getDistance(point3));
    }
} 
 