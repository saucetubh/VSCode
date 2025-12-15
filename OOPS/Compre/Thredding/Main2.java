class Job implements Runnable {
    private int i;
    public Job(int i) {
        this.i = i;
    }
    @Override
    public void run() {
        for(;;) {
            System.out.println(i++);
            try {
                Thread.sleep(500); //since this class doesnt extend thread, when using static methods of thread class, must use Thread.<method>
                //wait(500); //this is an instance method of object type. Gives error why??
            }
            catch (InterruptedException e) {
                throw new RuntimeException("sorry bruh"); //throwing this causes the thread to terminate
                //System.out.println("Thread interrupted"); //but if this was used then the thread would output this when interrupted and then continue executing
            }
        }
    }
}

public class Main2 {
    public static void main(String[] args) {
        Runnable j1 = new Job(5); //Job j1 = new  Job(5); both work
        Thread thr1 = new Thread(j1); //runtime polymorphism, Thread constructor takes any object that implements runnable, since j1 reference type is runnable it works. Would work even if previous line was Job j1
        thr1.start();
        Thread thr2 = new Thread(new Job(10));
        thr2.start();
        try{
            Thread.sleep(10000);
        }
        catch (InterruptedException e) {
            System.err.println("LOOOL");
        }
        thr1.interrupt();
    }
}