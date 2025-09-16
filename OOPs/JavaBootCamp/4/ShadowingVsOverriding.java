class SuperClass
{
    int x = 10;
 
    static int y = 20;

    void helper(){
        System.out.println("Non Static Function of SuperClass");
    }

    static void static_helper(){
        System.out.println("Static Function of SuperClass");
    }
}
 
class SubClass extends SuperClass
{
    //subclass hides superclass variables with same name
 
    int x = 30;
 
    static int y = 40;

    void helper(){
        System.out.println("Non Static Function of SubClass");
    }

    static void static_helper(){
        System.out.println("Static Function of SubClass");
    }
}
 
public class ShadowingVsOverriding
{
 
    public static void main(String[] args)
    {
        SubClass subClass = new SubClass();  //Creating object to SubClass
        //here both compile time type and runtime type is SubClass 
        System.out.println(subClass.x);   //Output : 30
        System.out.println(subClass.y);   //Output : 40
        subClass.helper();   //Output : Non Static Function of SubClass
        subClass.static_helper();   //Output : Static Function of SubClass

 
        SuperClass superClass = new SubClass();   
        //here compile-time type is SuperClass but runtime type is SubClass
        //Hiding/Shadowing: considers the compile time class
        //Overriding: considers the runtime class
        //Instance variables of SubClass shadow the instance variables of SuperClass
        //thus the variable of compile-time type is accessed i.e.SuperClass
        //Similarly, static variables of SubClass hide the instance variables of SuperClass
        //thus the variable of compile-time type is accessed i.e.SuperClass 
        //However, instance methods of SubClass OVERRIDE the instance methods of SuperClass
        //thus when accessing instance methods, runtime type is considered i.e. SubClass
        //But, static methods of SubClass HIDE the static methods of Superclass 
        //So the compile time type is used i.e. SuperClass
        System.out.println(superClass.x);     //Output : 10
        System.out.println(superClass.y);     //Output : 20
        superClass.helper();   //Output : Non Static Function of SubClass 
        //Note how the static function is hiding, NOT OVERRIDING the SuperClass function of the same name
        superClass.static_helper();   //Output : Static Function of SuperClass
    }
}
