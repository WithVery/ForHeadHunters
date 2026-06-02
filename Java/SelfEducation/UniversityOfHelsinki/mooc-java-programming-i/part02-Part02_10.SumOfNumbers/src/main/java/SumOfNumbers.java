
import java.util.Scanner;

public class SumOfNumbers {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        Integer sum = 0;
        while(true) {
            System.out.println("Give a number:");
            Integer value = Integer.valueOf(scanner.nextLine());
            if(value == 0) {
                break;
            }
            sum += value;
        }
        System.out.println("Sum of the numbers: " + sum);

    }
}
