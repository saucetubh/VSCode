import java.util.*;
public class Main {
    public static void main(String[] args) {
        List<String> students = new ArrayList<>();
        students.add("Alice");
        students.add("Bob");
        
        University uni = new University(students);
        
        uni.addMarks("Alice", "Math", 85);
        uni.addMarks("Alice", "Science", 92);
        uni.addMarks("Bob", "Math", 78);
        uni.addMarks("Bob", "Science", 88);
        
        uni.updateAttendance("Alice", 90);
        uni.updateAttendance("Bob", 80);
        
        uni.displayReport();
        uni.displayStudentReport("Alice");
        uni.topPerformer("Science");
        System.out.println("Average in Math: " + uni.averageMarks("Math"));  
    }
}