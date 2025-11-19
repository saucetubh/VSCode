import java.util.Scanner;
public class Input {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter your name: ");
        String name = sc.nextLine();
        System.out.println("Hello, " + name + "!");
        System.out.print("Enter your age: ");
        int age = sc.nextInt();
        System.out.println("You are " + age + " years old.");
        System.out.print("Enter your height in meters: ");
        double height = sc.nextDouble();
        System.out.println("Your height is " + height + " meters.");
        System.out.print("Enter your weight in kilograms: ");
        double weight = sc.nextDouble();
        System.out.println("Your weight is " + weight + " kilograms.");
        System.out.print("Enter your favorite character: ");
        char c = sc.next().charAt(0);
        System.out.println("Your favorite character is " + c + ".");
        sc.close();
    }
}
