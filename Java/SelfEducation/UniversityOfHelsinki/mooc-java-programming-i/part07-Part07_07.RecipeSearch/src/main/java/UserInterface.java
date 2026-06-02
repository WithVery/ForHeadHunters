import java.util.Scanner;

public class UserInterface {
    private Scanner scanner;
    private RecipeBook recipes;
    
    public UserInterface(Scanner scanner, RecipeBook recipes) {
        this.scanner = scanner;
        this.recipes = recipes;
    }
    
    public void start() {
        System.out.println("File to read: ");
        String filename = scanner.nextLine();
        
        recipes.loadFromFile(filename);
        
        while(true) {
            System.out.println("Commands:");
            System.out.println("list - lists the recipes");
            System.out.println("stop - stops the program");
            System.out.println("find name - searches recipes by name");
            System.out.println("find cooking time - searches recipes by cooking time");
            System.out.println("find ingredient - searches recipes by ingredient");
            System.out.println("");
            System.out.println("Enter command:");
            
            String command = scanner.nextLine();
            if(command.equals("list")) {
                System.out.println("Recipes:");
                System.out.println(recipes);
            } else if (command.equals("find name")) {
                System.out.println("Searched word: ");
                String name = scanner.nextLine();
                System.out.println("Recipes:");
                RecipeBook found = recipes.foundByName(name);
                System.out.println(found);
            } else if (command.equals("find cooking time")) {
                System.out.println("Max cooking time: ");
                Integer maxTime = Integer.valueOf(scanner.nextLine());
                System.out.println("Recipes:");
                RecipeBook found = recipes.foundByMaxTime(maxTime);
                System.out.println(found);
            } else if (command.equals("find ingredient")) {
                System.out.println("Ingredient: ");
                String ingredient = scanner.nextLine();
                System.out.println("Recipes:");
                RecipeBook found = recipes.foundByIngredient(ingredient);
                System.out.println(found);
            } else if (command.equals("stop")) {
                break;
            }





         }
        
    }
    
}
