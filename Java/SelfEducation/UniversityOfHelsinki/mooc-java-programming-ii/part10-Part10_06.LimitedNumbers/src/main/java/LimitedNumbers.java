
import java.util.ArrayList;
import java.util.Scanner;

public class LimitedNumbers {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        ArrayList<Integer> inputs = new ArrayList<>();
        
        while(true) {
            Integer input = Integer.valueOf(scanner.nextLine());
            if(input == -1) {
                break;
            }
            
            inputs.add(input);
        }
        
        inputs.stream().filter(input -> 1 <= input && input <= 5).forEach(input -> System.out.println(input));

    }
}
