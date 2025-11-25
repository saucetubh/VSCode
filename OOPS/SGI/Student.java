public class Student {
    String name;
    public Student(String name) {
        this.name = name;
    }
    public class Grade {
        int marks;
        public Grade(int marks) {
            this.marks = marks;
        }
        public String result() {
            if(this.marks >= 40) return "PASS";
            else return "FAIL";
        }
    }
    public Grade createGrade(int marks) {
        return this.new Grade(marks);
    }
}