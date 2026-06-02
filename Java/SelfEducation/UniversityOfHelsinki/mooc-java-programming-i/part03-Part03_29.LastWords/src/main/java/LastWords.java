
import java.util.Scanner;

public class LastWords {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        while(true) {
            String string = scanner.nextLine();
            
            if(string.equals("")) {
                break;
            }
            String[] lines = string.split(" ");
            System.out.println(lines[lines.length - 1]);
        }


    }
}
