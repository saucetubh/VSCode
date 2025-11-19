public class Main {
    public static void main(String[] args) {
        Hospital h = new Hospital();

        h.addPatient("Alice");
        h.addPatient("John");
        h.addEmergencyPatient("Mary");
        h.addEmergencyPatient("Steve");
        h.addPatient("Sydney Sweeney");
        h.addPatient("Abel");
        h.attendPatient(); // Steve (emergency)
        h.attendPatient(); // Mary (emergency)
        h.attendPatient(); // Alice (normal queue)
        h.attendPatient(); // John (normal queue)

        System.out.println("\nRemaining waiting list:");
        h.displayWaitingList();

        System.out.println("\nAttended patients (latest first):");
        h.displayAttendedPatients();
    }
}