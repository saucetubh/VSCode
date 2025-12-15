import java.io.*;

class LmaoException extends Exception {
    public LmaoException(String message) {
        super(message);
    }
}
public class Main {
    public static void main(String[] args) throws LmaoException {
        try {
            File f = new File("file.txt");
            FileInputStream fis = new FileInputStream(f); //reads bytes
            //FileReader fr = new FileReader(f); 
            InputStreamReader frd = new InputStreamReader(fis); //reads characters (bridge between byte streams and character streams)
            BufferedReader br = new BufferedReader(frd); //reads characters efficiently (buffering characters so as to provide efficient reading of characters, arrays, and lines)
            /*
            int c;
            while((c=fr.read()) != -1) { //some sort of type casting needed else it will output the ascii values of characters (since c is integer, and .read returns integer)
                System.out.println((char)c);
            }
            */
            String line;
            while((line = br.readLine()) != null) {
                System.out.println(line);
            }
            FileWriter fw = new FileWriter("file2.txt"); //creates a new file if it doesnt exist
            fw.write("lmao\n");
            fw.write("xd\n");
            fw.write("lol", 1,1); //writes only 'o' character
            System.out.println(f.canExecute());
            System.out.println(f.getName());
            fw.close();
            br.close();
            frd.close();
            fis.close();

        } 
        catch (FileNotFoundException e) { //thrown by FileInputStream, FileReader constructors
            System.err.println("The file doesnt exist u faggot"); //.err or .out doesnt matter
        }
        catch (IOException e) { //thrown by read(), readLine() etc
            throw new LmaoException("lol");
        }
        
    }
}