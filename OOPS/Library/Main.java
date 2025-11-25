public class Main {
    public static void main(String[] args) {
        Library l = new Library("BITS");
        //l.createBook("LOL", 100);
        //System.out.println(l.b.info());
        Library.Book b1 = l.new Book("Lol", 100);
        System.out.println(b1.info());
        Library.Book b2 = l.createBook("Lmao", 200);
        System.out.println(b2.info());
    }
}