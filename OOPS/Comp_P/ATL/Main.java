import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {

        // 1. Create an account with ID and initial balance
        Account acc = new Account(101, 1000);

        // 2. Create a list of transactions
        ArrayList<Integer> transactions = new ArrayList<>();
        transactions.add(200);    // deposit
        transactions.add(-300);   // withdrawal
        transactions.add(500);    // deposit
        transactions.add(-1600);  // should trigger exception
        transactions.add(400);

        // 3. Create the transaction task
        TransactionTask task = new TransactionTask(acc, transactions);

        // 4. Run task in a thread
        Thread t = new Thread(task);
        t.start();

        // 5. Wait for thread to finish (important for testing)
        try {
            t.join(); //this is really important otherwise main thread would finish and the last print statement below will just output the first balance
        } catch (InterruptedException e) {
            System.out.println("Main thread interrupted");
        }

        // 6. Final balance check
        System.out.println("Final balance: " + acc.getBalance());
    }
}