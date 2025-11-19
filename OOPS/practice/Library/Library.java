import java.util.*;
public class Library {
    public List<String> booksAvailable = new ArrayList<>();
    public Map<String, String> booksIssued; //simply creates a reference variable pointing at null

    public Library(List<String> books) {
        this.booksAvailable = books;
        this.booksIssued = new HashMap<>(); //creates an empty hashmap
        //this.booksAvailable = new ArrayList<>(); //this should be declared at the field, not here, check main file
    }
    public void issueBook(String name, String book) {
        if(booksAvailable.contains(book)) {
            booksAvailable.remove(book);
            booksIssued.put(name, book);
        }
        else {
            System.out.println("Book Not Available");
        }
    }
    public void returnBook(String name) {
        booksAvailable.add(booksIssued.get(name));
        booksIssued.remove(name, booksIssued.get(name)); //do remove after adding, otherwise it will give null
    }
    public void displayIssuedBooks() {
        for(Map.Entry<String, String> b : booksIssued.entrySet()) {
            System.out.println("Name: "+b.getKey()+" Book: "+b.getValue());
        }
    }
    public void displayAvailableBooks() {
        /*
        for(String s : this.booksAvailable) {
            System.out.println(s);
        }
        */
        Iterator<String> it = booksAvailable.iterator();
        while(it.hasNext()) {
            System.out.println(it.next());
        }
    }
}