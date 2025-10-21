public class Main {
    public static void main(String[] args) {

      System.out.println("Q1");
      Rectangle r1 = new Rectangle(100, 100, 10, 10, 2);
      r1.paintCalculation(10, 10, 2);
      System.out.println(r1.ps.colorPay);
      System.out.println("");

    System.out.println("Q2");
    Rectangle2 r2 = new Rectangle2(100, 100, 10, 10, 2);
    Rectangle2 r3 = new Rectangle2(100, 100, 20, 20, 2);
    System.out.println("r2 compared to r3 is "+r2.compareTo(r3));
    System.out.println("r2 compared to r2 is "+r2.compareTo(r2));
    System.out.println("r3 compared to r2 is "+r3.compareTo(r2));
}
}
