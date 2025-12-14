import java.util.*;
public class Hospital {
    Queue<String> waitingList; //Queue is a predefined interface in java
    Stack<String> emergencyStack; 
    List<String> attendedPatients; //List is a predefined interface in java

    public Hospital() {
        this.waitingList = new LinkedList<>(); //LinkedList is a concrete class in java implementing both queue and list interface
        this.emergencyStack = new Stack<>(); //Stack is a predefined concrete class in java
        this.attendedPatients = new ArrayList<>();
    }

    public void addPatient(String p) {
        waitingList.add(p);
        System.out.println("Patient "+p+" added to waiting list.");
    }
    public void addEmergencyPatient(String p) {
        emergencyStack.push(p);
        System.out.println("Patient "+p+" added to emergency list.");
    }
    public void attendPatient() {
        if(!emergencyStack.isEmpty()) {
            System.out.println("Attending Emergency Patient : "+emergencyStack.peek());
            attendedPatients.add(emergencyStack.pop());
        }
        else {
            System.out.println("Attending Patient : "+waitingList.peek());
            attendedPatients.add(waitingList.poll());
        }
    }
    public void displayWaitingList() {
        Iterator<String> it = waitingList.iterator(); //works for all in the collection datatype
        while(it.hasNext()) {
            System.out.println(it.next());
        }
    }
    public void displayAttendedPatients() { //to print in reverse order
        ListIterator<String> it = attendedPatients.listIterator(attendedPatients.size()); //sets the iterator at the end
        while(it.hasPrevious()) {
            System.out.println(it.previous());
        }
    }
}