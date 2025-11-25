interface Operation {
    int compute(int a, int b);
}
class Add implements Operation {
    public Add() {}; //does this have to be public or can it be private. Is this line even needed
    @Override
    public int compute(int a, int b) {
        return a+b;
    }
}

class Multiply implements Operation {
    //public Multiply() {}; //does this have to be public or can it be private. Is this line even needed //Line not needed, cannot be private
    @Override
    public int compute(int a, int b) {
        return a*b;
    }
}

class Subtract implements Operation {
    //public Subtract() {}; //does this have to be public or can it be private. Is this line even needed
    @Override
    public int compute(int a, int b) {
        return a-b;
    }
}

public class Main {
    public static void main(String[] args) {
        Add a = new Add();
        System.out.println(a.compute(5,3));
        System.out.println(new Subtract().compute(5,3));
        System.out.println(new Multiply().compute(5,3));
    }
}