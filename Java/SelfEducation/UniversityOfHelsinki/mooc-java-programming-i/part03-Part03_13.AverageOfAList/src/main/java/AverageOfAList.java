
import java.util.ArrayList;
import java.util.Scanner;

public class AverageOfAList {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // implement here a program, that first reads user input
        // adding them on a list until user gives -1.
        // Then it computes the average of the numbers on the list
        // and prints it.
        ArrayList<Integer> list = new ArrayList<>();
        while(true) {
            Integer value = Integer.valueOf(scanner.nextLine());
            if(value == -1) {
                break;
            }
            list.add(value);
        }
        
        Integer sum = 0;
        Integer count = 0;
        for(Integer val: list) {
            count++;
            sum += val;
        }
        System.out.println("Average: " + 1.0*sum/count);
        
    }
}
