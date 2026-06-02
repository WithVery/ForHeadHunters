
import java.util.Scanner;

public class SumOfASequenceTheSequel {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        Integer valFrom = Integer.valueOf(scanner.nextLine());
        Integer valTo = Integer.valueOf(scanner.nextLine());
        Integer sum = 0;
        for(int i = valFrom; i <= valTo; i++) {
            sum += i;
        }
        System.out.println("The sum is: " + sum);

    }
}
