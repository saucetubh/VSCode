import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.ListIterator;
public class Main {
    public static void main(String[] args) {
        MyQueue q = new MyQueue();

        q.enqueue(10);
        q.enqueue(20);
        q.enqueue(30);

        System.out.println("Front element: " + q.peek()); // 10
        System.out.println("Removed: " + q.dequeue());    // 10
        System.out.println("Removed: " + q.dequeue());    // 20

        q.enqueue(40);
        System.out.println("Front element: " + q.peek()); // 30
        System.out.println("Queue empty? " + q.isEmpty()); // false

        MyStack s = new MyStack();
        s.push(100);
        s.push(200);
        s.push(300);

        System.out.println("Top element: " + s.peek()); // 300
        System.out.println("Popped: " + s.pop());       // 300
        System.out.println("Popped: " + s.pop());       // 200
        s.push(400);
        System.out.println("Top element: " + s.peek()); // 400
        System.out.println("Stack empty? " + s.isEmpty()); // false
        //List<Integer> l = new ArrayList<>(); //list is an interface, to instantiate an object of reference type List we must use a class that implements the interface
        //although we can use ArrayList as the reference type too, but this is preferred since now we can use methods where any type of List is expected (Linked or Array)
        //example
        // This method is flexible. It only cares that it gets a "List".
        List<String> al = new ArrayList<>();
        al.add("a");
        al.add("b");        
        List<String> ll = new LinkedList<>();
//methods i can call depends on LHS i.e in this case only the methods deifned in list interface
//version of the methods implemented depends on the RHS object type (run time polymorphism, overriding methods)
        ll.add("x");
        ll.add("y");        
        printList(al);    // Output: a, b
        printList(ll);   // Output: x, y

        List<String> names = new ArrayList<>();
        names.add("Alice");
        names.add("Bob");
        names.add("Charlie");
        names.add(2, "Diana"); // Inserting at index 2
        printList(names); // Output: Alice, Bob, Diana, Charlie
        names.remove(3); // Removing element at index 3
        printList(names); // Output: Alice, Bob, Diana
        names.set(0, "Eve"); // Updating element at index 0
        names.remove(names.size() - 1); // Removing last element
        printList(names); // Output: Eve, Bob
        iter(names);
        iter2(names);
    }

    public static void printList(List<String> anyList) {
        for (String s : anyList) {
            System.out.println(s);
        }
    }
    public static void iter(List<String> anyList) {
        Iterator<String> it = anyList.iterator();
        while(it.hasNext()) {
            System.out.println(it.next());
        }
    }
    public static void iter2(List<String> anyList) {
        ListIterator<String> it = anyList.listIterator();
        while(it.hasNext()) {
            System.out.println(it.next());
        }
    }
    //ListIterator can do stuff like it.next, it.previous, it.add, it.remove
}