
import java.util.Scanner;

public class RepeatingBreakingAndRemembering {

    public static void main(String[] args) {
        
        // This exercise is worth five exercise points, and it is 
        // gradually extended part by part.
        
        // If you want, you can send this exercise to the server
        // when it's just partially done. In that case the server will complain about 
        // the parts you haven't done, but you'll get points for the finished parts.
        
        Scanner scanner = new Scanner(System.in);
        
        Integer sum = 0;
        Integer count = 0;
        Integer evens = 0;
        Integer odds = 0;
        System.out.println("Give numbers:");
        while(true) {
            Integer value = Integer.valueOf(scanner.nextLine());
            if(value == -1) {
                System.out.println("Thx! Bye!");
                break;
            }
            if(value % 2 != 0) {
                odds++;
            } else {
                evens++;
            }
            sum += value;
            count++;
        }
        System.out.println("Sum: " + sum);
        System.out.println("Numbers: " + count);
        System.out.println("Average: " + 1.0*sum/count);
        System.out.println("Even: " + evens);
        System.out.println("Odd: " + odds);

    }
}
