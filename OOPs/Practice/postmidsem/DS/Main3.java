import java.util.*;
public class Main3 {
    public static void main(String[] args) {
        Map<Integer, String> data = new HashMap<>();
        data.put(231, "Alice");
        data.put(145, "Bob");
        data.put(678, "Charlie");
        for(Map.Entry<Integer, String> e : data.entrySet()) {
            System.out.println("Roll No: "+e.getKey()+" Name: "+e.getValue());
        }
        System.out.println("Total Students: " + data.size());
        System.out.println("Student Names: " + data.values());
        System.out.println("Roll Numbers: " + data.keySet());
        System.out.println(data.containsKey(142));
        data.put(142, "Bob");
        System.out.println(data.containsKey(142));
        data.remove(231);
        for(Integer key : data.keySet()) {
            System.out.println("Roll No: "+key+" Name: "+data.get(key));
        }
        for(String v : data.values()) {
            System.out.println("Names: "+v);
        }
    }
}
//LinkedHashMap maintains insertion order
//TreeMap sorts the keys in natural (ascending) order
//HashMap does not guarantee any specific order
//simply change RHS in line 4 and see