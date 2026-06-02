
import java.util.Scanner;

public class SquareRootOfSum {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        Integer value1 = Integer.valueOf(scanner.nextLine());
        Integer value2 = Integer.valueOf(scanner.nextLine());
        System.out.println(Math.sqrt(value1 + value2));

    }
}
