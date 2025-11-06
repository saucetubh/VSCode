//Stacks are LIFO
//implementation of stack using array
/*
public class Stack { 
    private int[] arr;
    private int top;
    private int currentSize;

    public Stack(int size) {
        arr = new int[size];
        top = -1;
        currentSize = 0;
    }

    void push(int value) {
        if(top == arr.length - 1) throw new RuntimeException("Stack overflow");
        arr[++top] = value;
        currentSize++;
    }

    int pop() {
        if(top == -1) throw new RuntimeException("Stack Underflow");
        currentSize--;
        return arr[top--];
    }

    int peek() { //int top()
        if(top == -1) throw new RuntimeException("Empty Stack");
        return arr[top];
    }

    boolean isEmpty() {
        return (top == -1);
        // return (currentSize == 0);
    }

    int size() {
        return currentSize;
    }
}
*/
//implement using Array List
//can use inheritence or composition but composition is preferred since we dont want our stack to inherit all methods from array list

import java.util.ArrayList;

public class MyStack {
    private ArrayList<Integer> list;

    public MyStack() {
        list = new ArrayList<>();
    }

    void push(int value) {
        list.add(value);
    }
    int pop() {
        if (list.isEmpty()) {
            throw new RuntimeException("Stack Underflow");
        }
        return list.remove(list.size() - 1);
    }
    int peek() {
        if (list.isEmpty()) {
            throw new RuntimeException("Empty Stack");
        }
        return list.get(list.size() - 1);
    }
    boolean isEmpty() {
        return list.isEmpty();
    }
    int getSize() {
        return list.size();
    }
}