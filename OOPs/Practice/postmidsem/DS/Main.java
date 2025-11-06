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

    }
}