//thread implementation by extending the thread class, not preferred since one class can only extend one class, hence we make the class implement the runnable interface instead
class Speak extends Thread{ 
    private String msg;
    public Speak(String msg) {
        this.msg = msg;
    }
    @Override
    public void run() { //overrides the run() method from thread, which doesnt throw any checked exceptions, hence cannot add a throw clause here 
        for(;;) { //infinite loop
        System.out.println(msg);
        try {
        sleep(500); //declarative definition of this method throws exception i.e it is checked, hence must handle it somehow 
        }
        catch (InterruptedException e) {
            throw new RuntimeException("Get better"); //allowed to throw unchecked exceptions without declaring them in the method signature 
        }
        }
    }
}
public class Main {
    public static void main(String[] args) {
        Speak thr1 = new Speak("Ur gay");
        Speak thr2 = new Speak("No Lmao");
        thr2.start();
        thr1.start();
        thr1.interrupt();
    }
}