public class Triangle {
    private Point point1, point2, point3;
    public Triangle(int x1, int x2, int x3, int y1, int y2, int y3){
        point1 = new Point(x1, y1); //new keyword is necessary to create an object
        point2 = new Point(x2, y2);
        point3 = new Point(x3, y3);
    }
    public Triangle(Point point1, Point point2, Point point3){
        this.point1 = point1;
        this.point2 = point2;
        this.point3 = point3;
    }
    //Implement getters, setters 
    public Point getPoint1() {
        return this.point1;
    }
    public Point getPoint2() {
        return this.point2;
    }
    public Point getPoint3() {
        return this.point3;
    }
    //Implement given methods

    public boolean isIsosceles(){
        if (point1.getDistance(point2) == point1.getDistance(point3)) return true;
        else if (point2.getDistance(point3) == point1.getDistance(point2)) return true;
        else if (point2.getDistance(point3) == point1.getDistance(point3)) return true;
        else return false;
    }
    public boolean isEquilateral(){
        if (point1.getDistance(point2) == point1.getDistance(point3) && point2.getDistance(point3) == point1.getDistance(point3)) {
            return true;
        } else return false;
    }
    public boolean isCollinear(){
        if (getArea() == 0) return true;
        else return false;
    }
    public double getArea(){
        double Area = 0.5 * Math.abs(point1.getX() * (point2.getY() - point3.getY()) + point2.getX() * (point3.getY() - point1.getY()) + point3.getX() * (point1.getY() - point2.getY())); //verify this once
        return Area;
    }
}
