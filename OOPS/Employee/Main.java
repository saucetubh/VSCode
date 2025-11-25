interface Payable {
    double calculatePay();
}

abstract class Employee implements Payable {
    String name;
    double base;
    public Employee(String name, double base) {
        this.name = name;
        this.base = base;
    }
    static class Bonus {
        double bonus;
        public void addBonus(double pay, double bonusPercent) {
            this.bonus = pay * (bonusPercent/100);
        }
    }
}

class EmployeeF extends Employee {
    public EmployeeF(String name, double base) {
        super(name, base);
    }
    @Override
    public double calculatePay() {
        double pay;
        Employee.Bonus b = new Employee.Bonus();
        pay = (this.base * 1.2);
        b.addBonus(pay, 10);
        return (pay + b.bonus);
    }
}

class EmployeeP extends Employee {
    public EmployeeP(String name, double base) {
        super(name, base);
    }
    @Override
    public double calculatePay() {
        double pay;
        Employee.Bonus b = new Employee.Bonus();
        pay = (this.base * 0.6);
        b.addBonus(pay, 10);
        return (pay + b.bonus);
    }
}

public class Main {
    public static void main(String[] args) {
        EmployeeF e1 = new EmployeeF("John", 1000);
        EmployeeP e2 = new EmployeeP("Ria", 800);
        System.out.println(e1.calculatePay());
        System.out.println(e2.calculatePay());
    }
}



