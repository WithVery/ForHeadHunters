import java.util.Scanner;

public class UserInterface {
    private Scanner scanner;
    private BirdDB birds;
    
    public UserInterface(Scanner scanner, BirdDB birds) {
        this.scanner = scanner;
        this.birds = birds;
    }
    
    public void start() {
        
        while(true) {
            System.out.println("?");
            
            String command = scanner.nextLine();
            if(command.equals("Add")) {
                System.out.println("Name:");
                String name = scanner.nextLine();
                
                System.out.println("Name in Latin:");
                String nameLatin = scanner.nextLine();
                
                birds.add(new Bird(name, nameLatin));
            } else if (command.equals("All")) {
                birds.print();
            } else if (command.equals("One")) {
                System.out.println("Bird?");
                String name = scanner.nextLine();
                birds.print(name);
            } else if (command.equals("Observation")) {
                System.out.println("Bird?");
                String name = scanner.nextLine();
                birds.observation(name);
            } else if (command.equals("Quit")) {
                break;
            }





         }
        
    }
    
}
