import java.io.*;
public class Translate { 
    /*
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream(args[0]);
        int total = 0;
        while(fis.read() != -1) {
            total++;
        }
        fis.close();
        System.out.println(total+" bytes read");
    }
    */
   /*
   public static void main(String[] args) {
       try {
        FileInputStream fis = new FileInputStream(args[0]);
        int total = 0;
        byte a = (byte)args[1].charAt(0);
        byte b = (byte)args[2].charAt(0);
        int c;
        while((c=fis.read()) != -1) { //need to store what's read by fis into an appropriate variable
            if(a == c) {
                total++;
            }
        }
        fis.close();
        System.out.println(total+" bytes matched");
       }
       catch(IOException e) {
        System.out.println("IO Error: "+e);
       }
}
*/
/*
    public static void main(String[] args) throws IOException {
        byte a = (byte)args[0].charAt(0);
        byte b = (byte)args[1].charAt(0);
        int x;
        while ((x = System.in.read()) != -1) {
            System.out.write(x == a ? b : x);
        }
        System.in.close();
        System.out.close();
    }
*/
public static void main(String[] args) throws IOException {
    byte a = (byte)args[0].charAt(0);
    byte b = (byte)args[1].charAt(0);
    InputStreamReader isr = new InputStreamReader(System.in);
    BufferedReader br = new BufferedReader(isr);
    String line;
    while((line = br.readLine()) != null) {
        System.out.println(line.replace((char)a, (char)b));
        if(line.equals("exit")) {
            break;
        }
    }
    isr.close();
    br.close();
}

}