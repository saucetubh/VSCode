//Queues are FIFO
//Enqueue - add element to the rear
//Dequeue - remove element from the front
//Peek - get the front element without removing it
/*
public class Queue {
    private int[] arr;
    private int front;
    private int rear;

    public Queue(int size) {
        arr = new int[size];
        this.front = 0;
        this.rear = -1; //equivalent to top in stack
    }

    void enqueue(int value) { //int add()
        if(rear == arr.length - 1) throw new RuntimeException("Queue overflow");
        arr[++rear] = value;
    }

    int dequeue() { //int remove()
        if(front > rear) throw new RuntimeException("Queue Underflow");
        return arr[front++];
    }

    int peek() { //int first()
        if(front > rear) throw new RuntimeException("Empty Queue");
        return arr[front];
    }

    boolean isEmpty() {
        return (front > rear);
    }
}
*/

//implement using Linked List
//can use inheritence or composition but composition is preferred since we dont want our queue to inherit all methods from linked list

import java.util.LinkedList;

public class MyQueue {
    private LinkedList<Integer> list;

    public MyQueue() {
        list = new LinkedList<>();
    }

    void enqueue(int value) {
        list.addLast(value);
    }

    int dequeue() {
        if(list.isEmpty()) {
            throw new RuntimeException("Queue is empty");
        }
        return list.removeFirst();
    }

    int peek() {
        if(list.isEmpty()) {
            throw new RuntimeException("Queue is empty");
        }
        return list.getFirst();
    }

    boolean isEmpty() {
        return list.isEmpty();
    }

    int getSize() {
        return list.size();
    }

}