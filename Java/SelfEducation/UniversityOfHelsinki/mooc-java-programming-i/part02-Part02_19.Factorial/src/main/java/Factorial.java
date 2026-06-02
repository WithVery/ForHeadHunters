
import java.util.Scanner;

public class Factorial {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("Give a number:");
        Integer value = Integer.valueOf(scanner.nextLine());
        Integer fact = 1;
        
        for(int i = 1; i <= value; i++) {
            fact *= i;
        }
        System.out.println("Factorial: " + fact);

    }
}
