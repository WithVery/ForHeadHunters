
import java.util.Scanner;

public class NameOfTheOldest {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        Integer maxAge = -1;
        String maxName = "";
        while(true) {
            String string = scanner.nextLine();
            if(string.equals("")) {
                break;
            }
            
            String[] lines = string.split(",");
            
            Integer age = Integer.valueOf(lines[1]);
            if(age > maxAge) {
                maxAge = age;
                maxName = lines[0];
            }
        }
        System.out.println(maxName);


    }
}
