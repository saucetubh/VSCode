import java.io.*;
public class Main {
    public static void main(String[] args) throws IOException, FileNotFoundException {
        FileWriter f2 = new FileWriter("error.log");
        FileReader f1 = new FileReader("file.log");
        BufferedReader br = new BufferedReader(f1);
        BufferedWriter bw = new BufferedWriter(f2);
        String line;
        while((line=br.readLine())!=null) { //readline reads line by line, no need to worry
            if(line.substring(0,5).equals("ERROR")) {
                bw.write(line);
                bw.newLine();
            }
        }
        bw.close();
        br.close();
    }
}