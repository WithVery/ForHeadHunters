
import java.util.ArrayList;
import java.util.Scanner;

public class PersonalDetails {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        String maxName = "";
        Double sum = 0.0;
        Integer count = 0;
        
        while(true) {
            String string = scanner.nextLine();
            
            if(string.equals("")) {
                break;
            }
            String[] lines = string.split(",");
            if(maxName.length() < lines[0].length()) {
                maxName = lines[0];
            }
            
            sum += Double.valueOf(lines[1]);
            count++;
        }
        System.out.println("Longest name: " + maxName);
        System.out.println("Average of the birth years: " + sum / count);

    }
}
