import java.util.*;
class Student {
    private int id;
    private String name;
    private double cgpa;
    public Student (int id, String name, double cgpa) {
        this.cgpa=cgpa;
        this.id=id;
        this.name=name;
    }
    public int getid() {
        return this.id;
    }
    public double getcgpa() {
        return this.cgpa;
    }
    public static void doesnothing() {
        //does nothing
    }
}
class You extends Student {
    public You(int id, String name, double cgpa) {
        super(id, name, cgpa);
    }
    public void alsoDoesNothing() {
        super.doesnothing();
    }
}
public class Main { 
    public static double sum(List<Student> slist) {
        int sum=0;
        for(Student s : slist) {
            sum+=s.getcgpa();
        }
        return sum;
    }
    public static void main(String[] args) {
        List<Student> sr = new LinkedList<>();
        Student s1 = new Student(100, "Jamal", 7.7);
        Student s2 = new Student(101, "Bob", 9.7);
        sr.add(s2);
        sr.addFirst(s1);
        s1.doesnothing();
        You y = new You(103, "Alice", 8.9);
        y.alsoDoesNothing();
        sr.addLast(new Student(102, "Diddler", 8.6));
        System.out.println(sum(sr));
    }
}