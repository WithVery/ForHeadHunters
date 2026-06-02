
import java.util.Scanner;

public class AgeOfTheOldest {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        Integer max = -1;
        while(true) {
            String string = scanner.nextLine();
            if(string.equals("")) {
                break;
            }
            String[] lines = string.split(",");
            Integer age = Integer.valueOf(lines[1]);
            if(age > max) {
                max = age;
            }
        }
        System.out.println("Age of the oldest: " + max);


    }
}
