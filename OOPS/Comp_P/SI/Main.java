
import java.util.*;

public class Main { 
    public static void main(String[] args) {
        String answer = new String("");
        List<String> x = new LinkedList<>();
        x.add("Hello");
        x.add("You");
        x.add("Are");
        x.add("Gay");
        Iterator<String> i = x.iterator();
        while(i.hasNext()) {
            answer = answer.concat(i.next().substring(0,2));
        }
        System.out.println(answer);
        String answer2 = "";
        ListIterator<String> li = x.listIterator(x.size());
        while(li.hasPrevious()) {
            answer2=answer2.concat(li.previous());
        }
        System.out.println(answer2);
        System.out.println(max(answer, answer2));
    }

    public static <E extends Comparable<E>>E  max(E o1, E o2) { //return type is E and a generic that E must extend Comparable<E>
        if(o1.compareTo(o2) > 0) { //compares lexicographically, not by length
            return o1;
        }
        else {
            return o2;
        }
    }
}