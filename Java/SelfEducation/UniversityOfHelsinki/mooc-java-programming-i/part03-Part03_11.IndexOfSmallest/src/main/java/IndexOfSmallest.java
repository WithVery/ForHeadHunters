
import java.util.ArrayList;
import java.util.Scanner;

public class IndexOfSmallest {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // implement here a program that reads user input
        // until the user enters 9999
        ArrayList<Integer> list = new ArrayList<>();
        Integer minValue = Integer.MAX_VALUE;
        while(true) {
            Integer val = Integer.valueOf(scanner.nextLine());
            if(val == 9999) {
                break;
            }
            if(minValue > val) {
                minValue = val;
            }
            list.add(val);
        }
        
        // after that, the program prints the smallest number
        // and its index -- the smallest number
        // might appear multiple times
        System.out.println("Smallest number: " + minValue);
        for(int i = 0; i < list.size(); i++) {
            if(list.get(i) == minValue) {
                System.out.println("Found at index: " + i);
            }
        }
        
    }
}
