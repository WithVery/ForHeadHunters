
import java.util.Scanner;

public class AverageOfTwoNumbers {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Write your program here
        System.out.println("Give the first number:");
        Integer first = Integer.valueOf(scanner.nextLine());
        System.out.println("Give the second number:");
        Integer second = Integer.valueOf(scanner.nextLine());
        
        System.out.println( "The average is " + (0.5 * (first + second)));

    }
}
