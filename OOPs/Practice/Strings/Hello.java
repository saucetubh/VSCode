/*
public class Hello {
    public static void main(String[] args) {
        String s1 = args[0];
        System.out.println(s1);
        String s2 = args[1];
        System.out.println(s2);
        String s3 = s1.concat(s2);
        System.out.println(s3);
        String s4 = s1.substring(0,3) + s2.substring(4);
        System.out.println(s4);
    }

}
*/

//An alternate way to write code in OOPS style would be like this

class StringOperations {
    String s1;
    String s2;

    public StringOperations(String S1, String S2) {
        this.s1 = S1; //'this' is a reference to the current object being created
        this.s2 = S2;
    }

    public void performOperations() {
        System.out.println(s1);
        System.out.println(s2);
        System.out.println(s1.concat(s2));
        System.out.println(s1.substring(0,3) + s2.substring(4,5));
        System.out.println(5f/2); //type casting necessary, if only 5/2 then result is 2
        System.out.println(5/2.0); //this also works
        System.out.println(5/2); //this will give 2
        System.out.println((float)5/2); //this also works
    }
}

public class Hello {
    public static void main(String[] args) {
        StringOperations operations = new StringOperations(args[0], args[1]);
        operations.performOperations();
    }
}