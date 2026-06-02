import java.util.Scanner;

public class UserInterface {
    private Scanner scanner;
    private TodoList tasks;
    
    public UserInterface(TodoList tasks, Scanner scanner) {
        this.tasks = tasks;
        this.scanner = scanner;
    }
    
    public void start() {
        while(true) {
            System.out.println("Command: ");
            String command = scanner.nextLine();
            if(command.equals("stop")) {
                break;
            } else if(command.equals("add")) {
                System.out.println("To add: ");
                String task = scanner.nextLine();
                tasks.add(task);
            } else if(command.equals("list")) {
                tasks.print();
            } else if(command.equals("remove")) {
                System.out.println("To remove: ");
                Integer number = Integer.valueOf(scanner.nextLine());
                tasks.remove(number);
            } 
        }
    }
    
}
