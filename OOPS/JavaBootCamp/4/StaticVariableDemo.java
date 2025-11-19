// --- Level 1: The Top-Level Parent Class ---
class Device {
    // Public static variable
    public static String CATEGORY = "Electronic Device";
    // Public instance variable
    public String id = "D-001";
    // Private static variable - not accessible by subclasses
    private static int deviceCounter = 0;

    public Device() {
        deviceCounter++;
    }

    // Public static method
    public static void printCategory() {
        System.out.println("Device (static): " + CATEGORY);
    }

    // Public instance method
    public void printId() {
        System.out.println("Device (instance): id = " + this.id);
    }

    public static int getDeviceCount() {
        return deviceCounter;
    }
}

// --- Level 2: The Mid-Level Subclass ---
class Computer extends Device {
    // HIDES the parent's static variable with a more specific, protected one.
    protected static String CATEGORY = "Computing Device";
    // SHADOWS the parent's instance variable. This is a new, separate variable.
    public String id = "C-002";

    // HIDES the parent's static method.
    public static void printCategory() {
        System.out.println("Computer (static): " + CATEGORY);
        // We can still access the parent's hidden static member using 'super' context, but it's tricky.
        // The standard way is to use the parent class name directly.
        System.out.println("  -> Accessing parent static category: " + Device.CATEGORY);
    }

    // OVERRIDES the parent's instance method.
    @Override
    public void printId() {
        System.out.println("Computer (instance): id = " + this.id);
        // Use 'super' to call the parent's overridden method.
        System.out.println("  -> Accessing parent instance id via super: " + super.id);
    }
}

// --- Level 3: The Lowest-Level Subclass ---
class Laptop extends Computer {
    // HIDES the static variable from both parents.
    public static String CATEGORY = "Portable Computer";
    // SHADOWS the instance variable from both parents.
    public String id = "L-003";

    // HIDES the static methods from both parents.
    public static void printCategory() {
        System.out.println("Laptop (static): " + CATEGORY);
    }

    // OVERRIDES the instance method from both parents.
    @Override
    public void printId() {
        System.out.println("Laptop (instance): id = " + this.id);
        System.out.println("  -> Accessing parent instance id via super: " + super.id);
    }
}


public class StaticVariableDemo {
    public static void main(String[] args) {
        System.out.println("--- Advanced Demo: Hiding, Shadowing, and Overriding ---");

        // --- Setup: Create a Laptop object, but use references of its parent types.
        Device deviceRef = new Laptop();
        Computer compRef = new Laptop();
        Laptop laptopRef = new Laptop();

        System.out.println("\n--- 1. Calling STATIC methods on different references ---");
        System.out.println("The output depends on the REFERENCE type (Compile-Time Binding).");
        deviceRef.printCategory();  // Calls Device's static method
        compRef.printCategory();    // Calls Computer's static method
        laptopRef.printCategory();  // Calls Laptop's static method

        System.out.println("\n--- 2. Calling INSTANCE methods on different references ---");
        System.out.println("The output depends on the OBJECT's type (Runtime Polymorphism).");
        deviceRef.printId();    // All three call the Laptop's overridding method
        compRef.printId();     
        laptopRef.printId();

        System.out.println("\n--- 3. Accessing STATIC variables via references ---");
        System.out.println("Like static methods, this depends on the REFERENCE (compile-time) type.");
        System.out.println("deviceRef.CATEGORY -> " + deviceRef.CATEGORY);   // Accesses Device.CATEGORY
        System.out.println("compRef.CATEGORY   -> " + compRef.CATEGORY);   // Accesses Computer.CATEGORY
        System.out.println("laptopRef.CATEGORY -> " + laptopRef.CATEGORY); // Accesses Laptop.CATEGORY

        System.out.println("\n--- 4. Accessing INSTANCE variables via references ---");
        System.out.println("Instance variable access is NOT polymorphic. It also depends on REFERENCE type.");
        System.out.println("deviceRef.id -> " + deviceRef.id);   // Accesses the 'id' field defined in Device
        System.out.println("compRef.id   -> " + compRef.id);   // Accesses the 'id' field defined in Computer
        System.out.println("laptopRef.id -> " + laptopRef.id); // Accesses the 'id' field defined in Laptop

        System.out.println("\n--- 5. Private static member access ---");
        // System.out.println(Device.deviceCounter); // COMPILE ERROR! private access.
        System.out.println("Total devices created (via public static getter): " + Device.getDeviceCount()+"\n");

        Computer cobj=new Laptop();
        cobj.printCategory(); //Accesses function of Computer
        cobj.printId(); //Accesses function of Laptop
        System.out.println(cobj.id); //Accesses variable of Computer
        System.out.println(cobj.CATEGORY); //Accesses variable of Computer
    }
}

