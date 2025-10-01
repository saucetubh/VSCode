public class Main {
    public static void main(String[] args) {
        /*
            TODO:
            Create an object 'p' compatible with the main function below.
            The 'weight' of the pacakge is 10.
            Ensure that your output matches the expectation.
        */
        Package p = new ExpressPackage(999, 10.0, 50.0); //Polymorphism. P is an object of the Package type but i have called the constructor of express package type
        System.out.println("Package ID: " + p.getID());
        // Expected: Package ID: 999

        System.out.println("Normal cost: " + p.calculateCost(20));
        // Expected: Normal cost: 250.0
//this must be an express package with a fee of 50
        System.out.println("Insured cost: " + p.calculateCost(20, 100));
        // Expected: Insured cost: 300.0
    }
}

//notice that expresspackage does not have a getID method, only the Package class has it
//problem also says that we cannot override the getID method in package class i.e we cannot create an ExpressPackage class with a getID method
//this brings us to the concept of Polymorphism. 
