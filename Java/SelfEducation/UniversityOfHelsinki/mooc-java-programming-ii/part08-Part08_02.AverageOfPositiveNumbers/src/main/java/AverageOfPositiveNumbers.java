
import java.util.Scanner;
import java.util.ArrayList;

public class AverageOfPositiveNumbers {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        ArrayList<Integer> ints = new ArrayList<>();
        
        while(true) {
            Integer val = Integer.valueOf(scanner.nextLine());
            if(val == 0) {
                break;
            }
            
            if(0 < val) {
                ints.add(val);
            }
        }
        
        if(ints.size() > 0) {
            int count = 0;
            double sum = 0;

            for(Integer int1: ints) {
                sum += int1;
                count++;
            }
            System.out.println(sum / count);
        } else {
            System.out.println("Cannot calculate the average");
        }
    }
}
