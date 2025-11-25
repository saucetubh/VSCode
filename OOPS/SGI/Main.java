public class Main {
    public static void main(String[] args) {
        Student s1 = new Student("Amit");
        Student s2 = new Student("Ria");
        System.out.println(s1.new Grade(78).result());
        System.out.println(s2.new Grade(32).result());        
    }
}