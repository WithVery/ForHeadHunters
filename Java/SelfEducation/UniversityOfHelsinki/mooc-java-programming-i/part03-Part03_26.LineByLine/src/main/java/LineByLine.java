
import java.util.Scanner;

public class LineByLine {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        while(true) {
            String string = scanner.nextLine();
            if(string.equals("")) {
                break;
            }
            
            String[] lines = string.split(" ");
            for(int i = 0; i < lines.length; i++) {
                System.out.println(lines[i]);
            }
        }

    }
}
