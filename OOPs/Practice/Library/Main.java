import java.util.*;
public class Main {
    public static void main(String[] args) {
        List<String> books = new ArrayList<>();
        books.add("Java Programming");
        books.add("Database Systems");
        books.add("Computer Networks");
        
        Library lib = new Library(books);
        lib.displayAvailableBooks();
        lib.issueBook("Alice", "Java Programming");
        lib.issueBook("Bob", "Database Systems");
        lib.displayIssuedBooks();
        lib.displayAvailableBooks();
        
        lib.returnBook("Alice");
        lib.displayAvailableBooks();
        lib.displayIssuedBooks();
    }
}
