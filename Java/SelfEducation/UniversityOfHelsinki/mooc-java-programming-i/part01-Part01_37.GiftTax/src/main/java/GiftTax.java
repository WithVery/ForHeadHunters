
import java.util.Scanner;

public class GiftTax {

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        double tax = 0;
        
        System.out.println("Value of the gift?");
        Integer value = Integer.valueOf(scan.nextLine());
        if (value < 5000) {
            tax = 0;
        } else if (value < 25000) {
            tax = 100.0 + 0.08 * (value - 5000);
        } else if ((value < 55000)) {
            tax = 1700.0 + 0.10 * (value - 25000);
        } else if ((value < 200000)) {
            tax = 4700.0 + 0.12 * (value - 55000);
        } else if ((value < 1000000)) {
            tax = 22100.0 + 0.15 * (value - 200000);
        }  else {
            tax = 142100.0 + 0.17 * (value - 1000000);
        }

        if(0 < tax) {
            System.out.println("Tax " + tax);
        } else {
            System.out.println("No tax!");
        }
    }
}
