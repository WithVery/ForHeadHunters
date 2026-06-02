
import java.util.Scanner;

public class AverageOfNumbers {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        Integer sum = 0;
        Integer count = 0;
        while(true) {
            System.out.println("Give a number:");
            Integer value = Integer.valueOf(scanner.nextLine());
            if(value == 0) {
                break;
            }
            sum += value;
            count++;
        }
        System.out.println("Average of the numbers: " + 1.0*sum/count);
    }
}
