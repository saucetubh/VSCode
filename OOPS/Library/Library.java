public class Library {
    //Book b;
    String name;
    public Library(String name) {
        this.name = name;
    }
    class Book {
        String title;
        int pages;
        public Book(String title, int pages) {
            this.title = title;
            this.pages = pages;
        }
        public String info() {
            String s = new String("Library: "+Library.this.name+" Book: "+this.title+" Pages: "+this.pages);
            return s;
        }
    }
    public /*void*/ Book createBook(String title, int pages) {
        //this.b = this.new Book(title, pages);
        return this.new Book(title, pages);
    }
}