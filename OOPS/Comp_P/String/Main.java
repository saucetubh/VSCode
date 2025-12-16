import java.util.*;
public class Main {
    public static void main(String[] args) {
        String[] arr = new String[]{"lolfwr3", "924fwr2925", "10s24e024", "lm42wuwirao", "gawdda13ey", "-1cbsfse210", "y3fw224o", "67.85625262"};
        System.out.println(sumnum(arr));
        System.out.println(diff(arr));
    }
    static double sumnum(String[] arr) {
        double sum=0;
        for(String s : arr) {
            try {
            double num = Double.parseDouble(s);
            sum = sum+num;
            }
            catch(Exception e) {}
        }
        return sum;
    }
    static boolean diff(String[] arr) {
        boolean flag = true;
        for(String s : arr) {
            Set<Character> unique = new HashSet<>();
            for(char c : s.toCharArray()) {
                unique.add(c);
            }
            if(unique.size() < 5) {
                return false;
            }
        }
        return flag;
    }
    static boolean repeat(String s) {
        Set<String> set = new HashSet<>();
        for(int i=0;i<s.length()-3;i++) {
            String s1=s.substring(i, i+3);
            if(set.contains(s1)){return true;}
            else {set.add(s1);}
        }
        return false;
    }
    static boolean count(String[] arr) {
        
    }
}
