
import java.util.ArrayList;
import java.util.Scanner;

public class AverageOfNumbers {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        // Write your program here

        ArrayList<String> values = new ArrayList<>();
        while(true) {
            String string = scanner.nextLine();
            if(string.equals("end")) {
                break;
            } else {
                values.add(string);
            }
        }
        
        double average = values.stream().mapToInt(s -> Integer.valueOf(s)).average().getAsDouble();
        
        System.out.println("average of the numbers: " + average);
        
    }
}
