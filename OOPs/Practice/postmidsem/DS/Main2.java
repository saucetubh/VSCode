import java.util.*;
public class Main2 {
    public static void main(String[] args) {
        List<String> names = new LinkedList<>();
        List<Integer> marks = new ArrayList<>();
        //ListIterator<String> it1 = names.listIterator(); this will not work, iterator is synced to an empty list. Iterator must be defined after list is modified
        //ListIterator<Integer> it2 = marks.listIterator();
        names.add("Bob");
        marks.add(0);
        marks.add(0);
        marks.add(0);
        marks.add(0);
        marks.add(0);
        names.add("John");
        names.add("Mary");
        names.add("Juan");
        names.add("Lana");
        names.remove("John");
        //marks.set(names.indexOf("John"), 20);
        marks.set(names.indexOf("Lana"), 70);
        marks.set(names.indexOf("Juan"), 100);
        marks.set(names.indexOf("Mary"), 50);
        ListIterator<String> it1 = names.listIterator();
        ListIterator<Integer> it2 = marks.listIterator();
        it1.add("Doe"); //iterator is before index 0 when created, so adding here adds at index 0, and now index is between 0 and 1 so it starts printing from index 1 unless we do it1.previous();
        it1.next();
        it1.next();
        it1.add("Anna");
        it1.next();
        it1.remove();
        it1 = names.listIterator(); //reset iterator to start
        while(it1.hasNext()) {
            System.out.println(it1.next());
        }
        for(Integer i : marks) {
            System.out.println(i);
        }
        //think of iterator as your cursor in a text editor
    }
}