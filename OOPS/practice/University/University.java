import java.util.*;
public class University {
    List<String> studentNames = new ArrayList<>();
    Map<String, Map<String, Integer>> studentData;
    Map<String, Integer> attendance;

    public University(List<String> names) {
        this.studentData = new HashMap<>();
        this.attendance = new HashMap<>();
        this.studentNames = names;
    }

    public void addMarks(String name, String subject, int marks) {
        if(!studentData.containsKey(name)) { //necessary since we would hv to initialise and create an empty hashmap
            Map<String, Integer> grades = new HashMap<>();
            studentData.put(name, grades);
        }
        studentData.get(name).put(subject, marks);
    }
    public void updateAttendance(String name, int percentage) {
        attendance.put(name, percentage); //automatically creates a new pair if not present, or updates value if key already present
    }
    public void displayReport() {
        for(Map.Entry<String, Map<String, Integer>> i : studentData.entrySet()) {
            System.out.println("Name: "+i.getKey()+". Grades: "+i.getValue());
        }
    }
    public void displayStudentReport(String name) {
        //Map<String, Integer> grades = studentData.get(name);
        System.out.println("Report for: " +name);
        for(Map.Entry<String, Integer> i : studentData.get(name).entrySet()) {
            System.out.println(" Subject: " + i.getKey() + ", Marks: " + i.getValue());
        }
        System.out.println(" Attendance: " + attendance.get(name) + "%");
    }
    public void topPerformer(String subject) {
        int max = -1;
        String s = "None";
        for(String k : studentData.keySet()) {
            if(studentData.get(k).get(subject) > max) {
                max = studentData.get(k).get(subject);
                s = k;
            }
        }
        System.out.println("Top Performer is: "+s+". Marks = "+max);
    }
    public double averageMarks(String subject) {
        double sum = 0;
        for(String k : studentData.keySet()) {
            sum = sum + studentData.get(k).get(subject);
        }
        return sum/studentData.size();
    }
}