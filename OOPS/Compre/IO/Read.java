import java.io.*;
public class Read {
    public static void main(String[] args) throws IOException {
        InputStreamReader isr = new InputStreamReader(System.in);
        
        BufferedReader bsr = new BufferedReader(isr);
        /*
        String line;
        while((line = bsr.readLine()).length() != 0) {
            System.out.println(line);
        }
        bsr.close();
        */
       /*
        int c;
        while((c=isr.read()) != -1) {
            System.out.println((char)c);
        }
        isr.close();
        */
        //program doesnt terminate since every input from keyboard has a unicode value, use ctrl + C
        char c;
        while((c=(char)bsr.read()) != 'q') {
            System.out.println(c);
        }
        bsr.close();
    }
}