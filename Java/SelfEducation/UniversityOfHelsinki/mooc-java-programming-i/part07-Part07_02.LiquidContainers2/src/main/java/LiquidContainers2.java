
import java.util.Scanner;

public class LiquidContainers2 {

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        
        Container first = new Container();
        Container second = new Container();

        while (true) {
            System.out.print("> ");

            System.out.println("First: " + first);
            System.out.println("Second: " + second);
            
            String input = scan.nextLine();
            if (input.equals("quit")) {
                break;
            }
            
           String[] commands = input.split(" ");
            if(commands[0].equals("add")) {
                int amount = Integer.valueOf(commands[1]);
                if (amount > 0) {
                    first.add(amount);
                }
            } else if(commands[0].equals("move")) {
                int amount = Integer.valueOf(commands[1]);
                if (amount > 0) {
                    if (first.contains() < amount) amount = first.contains();
                    first.remove(amount);
                    second.add(amount);
                }
            } else if(commands[0].equals("remove")) {
                int amount = Integer.valueOf(commands[1]);
                if (amount > 0) {
                    second.remove(amount);
                }
            }            

        }
    }

}
