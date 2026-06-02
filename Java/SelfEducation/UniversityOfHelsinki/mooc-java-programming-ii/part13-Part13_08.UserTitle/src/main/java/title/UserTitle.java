package title;

import java.util.Scanner;
import javafx.application.Application;

public class UserTitle {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Title?");
        String title = scanner.nextLine();
        args = new String[1];
        args[0] = "--Title=" + title;
        Main.main(args);
    }

}
