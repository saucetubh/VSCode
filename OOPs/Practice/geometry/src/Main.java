package geometry.src; //this works when the folder i open in vscode is geometry, it needs to be the root folder
import geometry.three.Sphere;
interface myComparable {
    int compareTo(Object o);
}
public class Main {
    public static void main(String[] args) {
        Circle c1 = new Circle(5);
        Sphere s1 = new Sphere(10);
        myComparable c2 = new Circle(7); //since referencing type is myComparable, we can only access methods of myComparable interface
        //c2.getRadius(); // This will give an error because getRadius() is not defined in myComparable interface. Typecast needed
        ((Circle)c2).getRadius(); // Typecasting to Circle to access getRadius() method
        Circle c3 = (Circle)c2; // Typecasting to Circle to access getRadius() method
        c3.getRadius();
    }
}
//since main is in a folder, it is not in the same default package as Circle and Sphere, so we need to package and import them
//if we place main in the geometry folder, i.e without making a src folder, we won't need to import the classes since they will be in the same package