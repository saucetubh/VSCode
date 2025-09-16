/**
 * This class demonstrates the initialization order of static blocks and
 * static variables in an inheritance hierarchy.
 * The rule is: A parent class MUST be loaded and initialized before its child class.
 * This process happens only ONCE per class, the very first time it's used.
 */

// Top-level Parent Class
class Component {
    // Static variable initializer runs when the class is loaded.
    static String staticComponentId = staticAssignId("Component");
    
    //Non Static variable initializer runs when the class is loaded.
    String componentId = assignId("Component");

    // Static block, runs right after static variable initializers.
    static {
        System.out.println("1. Component static block executed.");
    }
    //Non static initializer block
    {
        System.out.println("Non static initializer block of Component.");
    }

    // Helper method to show when initializers are running.
    static String staticAssignId(String name) {
        System.out.println("-> Initializing static variable for: " + name);
        return name + "-ID";
    }
    // Helper method to show when initializers are running.
    String assignId(String name) {
        System.out.println("-> Initializing non static variable for: " + name);
        return name + "-ID";
    }
}

// Mid-level Child Class
class Button extends Component {
    static String buttonId = staticAssignId("Button");
    String componentId = assignId("Button");
    static {
        System.out.println("2. Button static block executed.");
    }
    //Non static initializer block
    {
        System.out.println("Non static initializer block of Button.");
    }
}

// Lowest-level Child Class
class SubmitButton extends Button {
    static String submitId = staticAssignId("SubmitButton");
    String componentId = assignId("SubmitButton");
    static {
        System.out.println("3. SubmitButton static block executed.");
    }
    //Non static initializer block
    {
        System.out.println("Non static initializer block of SubmitButton.");
    }
}

public class InitializationOrderDemo {
    public static void main(String[] args) {
        System.out.println("\n--- DEMONSTRATION: STATIC INITIALIZATION ORDER ---");
        System.out.println("\nMain method starting. No classes loaded yet...");
        System.out.println("Creating the first SubmitButton object. This will trigger class loading.");


        // The moment the JVM sees 'SubmitButton', it starts the class loading process.
        // It sees SubmitButton extends Button, which extends Component.
        // So, it must load and initialize Component, then Button, then SubmitButton.
        new SubmitButton();

        System.out.println("\nFirst SubmitButton object has been created.");
        System.out.println("----------------------------------------------");
        System.out.println("Creating a second SubmitButton object.");

        // Since all classes are already loaded and initialized, the static blocks
        // and initializers WILL NOT run again.
        new SubmitButton();
        System.out.println("Second SubmitButton object created. No static blocks were executed.\n");

        System.out.println("Thus, the order of initialization is:");
        System.out.println("1. Parent static variable initialization");
        System.out.println("2. Parent static block");
        System.out.println("3. Child static variable initialization");
        System.out.println("4. Child static block");
        System.out.println("5. Parent non-static variable initialization");
        System.out.println("6. Parent non-static block");
        System.out.println("7. Child non-static variable");
        System.out.println("8. Child non-static block");
    }
}

