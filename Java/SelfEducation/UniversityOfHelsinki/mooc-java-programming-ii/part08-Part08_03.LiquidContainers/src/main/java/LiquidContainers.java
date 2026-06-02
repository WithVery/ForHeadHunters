
import java.util.Scanner;

public class LiquidContainers {

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        
        int first = 0;
        int second = 0;
        int totalAmount = 100;


        while (true) {
            //System.out.print("> ");
            System.out.println("First: " + first + "/" + totalAmount);
            System.out.println("Second: " + second + "/" + totalAmount);

            String input = scan.nextLine();
            if (input.equals("quit")) {
                break;
            }
            
            String[] commands = input.split(" ");
            
            String command = commands[0];
            Integer amount = Integer.valueOf(commands[1]);
            if(amount > 0) {
                if (command.equals("add")) {
                    if(amount > 0) {
                        first += amount;
                        if(first > 100) first = 100;
                    }
                } else if (command.equals("move")) {
                    if(first < amount) amount = first;
                    first -= amount;
                    second += amount;
                    if(second > 100) second = 100;
                } else if(command.equals("remove")) {
                    second -= amount;
                    if(second <0) second = 0;
                }
            }

        }
    }

}
