
import java.util.Scanner;

public class FromWhereToWhere {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Where to?");
        Integer valueTo = Integer.valueOf(scanner.nextLine());
        System.out.println("Where from?");
        Integer valueFrom = Integer.valueOf(scanner.nextLine());
        for(int i = valueFrom; i <= valueTo; i++) {
            System.out.println(i);
        }
    }
}
