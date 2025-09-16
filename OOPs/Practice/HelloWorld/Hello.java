public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello");
        World world = new World();
        world.sayWorld();
    }
}

/*
class World {
    public static void main(String[] args) {
        System.out.println("World!");
    }
}
*/ 

//if i do java Hello only code inside main of class Hello will run
//if i do java World only code inside main of class World will run
//JVM only executes the main method of the specified class
//So if there are multiple classes with main methods, only the specified class's main method will be executed.
//Any other class without a main method wont run, unless called from another class with a main method.
//It is preferred to have a single main method as the entry point for the application.

class World {
    void sayWorld() {
        System.out.println("World!");
    }
}

//now this class does not have a main method, to use this you can create objects of the World class
//and call its methods inside the main method of the public class
