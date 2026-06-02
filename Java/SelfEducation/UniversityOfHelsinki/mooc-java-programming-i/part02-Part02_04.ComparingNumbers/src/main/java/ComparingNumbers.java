
import java.util.Scanner;

public class ComparingNumbers {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        Integer value1 = Integer.valueOf(scanner.nextLine());
        Integer value2 = Integer.valueOf(scanner.nextLine());
        if(value1 < value2) {
            System.out.println(value1 + " is smaller than " + value2 + ".");
        } else if(value1 == value2) {
            System.out.println(value1 + " is equal to " + value2 + ".");
        } else {
            System.out.println(value1 + " is greater than " + value2 + ".");
        }
    }
}
