
import java.util.ArrayList;
import java.util.Scanner;

public class AverageOfSelectedNumbers {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        // toteuta ohjelmasi tänne
        ArrayList<String> values = new ArrayList<>();
        
        System.out.println("Input numbers, type \"end\" to stop.");
        while(true) {
            String value = scanner.nextLine();
            if(value.equals("end")) {
                break;
            }
            values.add(value);
        }

        System.out.println("Print the average of the negative numbers or the positive numbers? (n/p)");
        String answer = scanner.nextLine();

//        System.out.println(
//                values.stream().mapToInt(s -> Integer.valueOf(s))
//                .filter(number -> (answer.equals("n") && number < 0) || (answer.equals("p") && number > 0)).average().getAsDouble()); //.count());
//        
        
        double average = values.stream().mapToInt(s -> Integer.valueOf(s))
                .filter(number -> (answer.equals("n") && number < 0) || (answer.equals("p") && number > 0))
                .average().getAsDouble();
        System.out.println("average of the " + (answer.equals("n") ? "negative" : "positive") + " numbers: " + average);
    }
}
