import java.io.*;
import java.util.*;
public class TransactionTask implements Runnable {
    private Account acc;
    private ArrayList<Integer> transactions;
    private File resultFile;
    public TransactionTask(Account acc, ArrayList<Integer> transactions) {
        this.acc = acc;
        this.transactions = transactions;
        resultFile = new File("acc_"+acc.getId()+".txt");
    }
    @Override
    public void run() {
        try {
        processTransactions();
        }
        catch(IOException e) {
        }
    }
    public void processTransactions() throws IOException {
        FileWriter fw = new FileWriter(resultFile);
        for(Integer i : transactions) {
            try {
                acc.applyTransaction(i);
            }
            catch (InsufficientBalanceException e) {
                System.err.println(e.getMessage());
            }
            fw.write(Integer.toString(acc.getBalance()));
            fw.write('\n'); //placement of these statements is very important, if exception encountered, everything after it inside the try isnt executed and it goes to catch
        }
        fw.close();
    }
}
