
import java.util.Scanner;

public class AbsoluteValue {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        Integer value = Integer.valueOf(scanner.nextLine());
        if (value < 0) {
            System.out.println(-value);
        } else {
            System.out.println(value);
        }

    }
}
