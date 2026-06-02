
import java.util.Scanner;

public class AverageOfPositiveNumbers {

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
            if(value < 0) {
                continue;
            }
            sum += value;
            count++;
        }
        if(count > 0) {
            System.out.println(1.0*sum/count);
        } else {
            System.out.println("Cannot calculate the average");
        }
    }
}
