import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Integer> fixedDeposit = new ArrayList<Integer>();
        fixedDeposit.add(Integer.valueOf(1000));
        fixedDeposit.add(Integer.valueOf(2000));
        fixedDeposit.add(Integer.valueOf(3000));
        System.out.println("Q1");
        SavingsAccount sa = new SavingsAccount(10000, fixedDeposit);
        sa.interestCalculation(10);
        System.out.println(sa.interestDetails.values());

       
        //Output
        // Q1
        // [10000, 20000, 30000]
    }
}
