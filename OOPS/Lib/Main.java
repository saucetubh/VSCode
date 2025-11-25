class Library {
    private String libName;
    public Library(String libName) {
        this.libName = libName;
    }
    class Book {
        private String title;
        private int pages;
        public Book(String title, int pages) {
            this.title = title;
            this.pages = pages;
        }
        public void info() {
            System.out.println("libName: "+Library.this.libName+", title: "+this.title+", pages: "+this.pages);
        }

    }
}

public class Main {
    public static void main(String[] args) {
        Library l1 = new Library("BITS GOA");
        Library.Book b = l1.new Book("Bio", 100);
        Library.Book b2 = l1.new Book("Chem", 200);
        b.info();
        b2.info();
        Library.Book b3 = new Library("TITS GOA").new Book("Maths", 300);
        b3.info();
    }
}