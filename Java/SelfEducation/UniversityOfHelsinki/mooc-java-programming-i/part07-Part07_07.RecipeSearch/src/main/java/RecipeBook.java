import java.util.ArrayList;
import java.util.Scanner;
import java.nio.file.Paths;
import java.io.IOException;

public class RecipeBook {
    private ArrayList<Recipe> recipes;
    
    public RecipeBook() {
        recipes = new ArrayList<>();
    }

    public void add(Recipe recipe) {
        recipes.add(recipe);
    }
    
    public void loadFromFile(String filename) {
        try (Scanner scanner = new Scanner(Paths.get(filename))) {
            while(scanner.hasNextLine()) {
                String name = scanner.nextLine();
                Integer time = Integer.valueOf(scanner.nextLine());
                Recipe recipe = new Recipe(name, time);
                
                while(scanner.hasNextLine()) {
                    String ingredient = scanner.nextLine();
                    if(ingredient.isEmpty()) break;
                    recipe.addIngredient(ingredient);
                }
                
                recipes.add(recipe);
            }
        } catch (IOException e) {
            System.out.println("exception");
        }
    }
    
//    public ArrayList<Recipe> foundByName(String name) {
//        ArrayList<Recipe> found = new ArrayList<>();
//        for(Recipe recipe: recipes)
//            if (recipe.getName().contains(name)) found.add(recipe);
//        return found;
//    }
    public RecipeBook foundByName(String name) {
        RecipeBook found = new RecipeBook();
        for(Recipe recipe: recipes)
            if (recipe.getName().contains(name)) found.add(recipe);
        return found;
    }

    public RecipeBook foundByMaxTime(int time) {
        RecipeBook found = new RecipeBook();
        for(Recipe recipe: recipes)
            if (recipe.getTime() <= time) found.add(recipe);
        return found;
    }

    public RecipeBook foundByIngredient(String ingredient) {
        RecipeBook found = new RecipeBook();
        for(Recipe recipe: recipes)
            if (recipe.containsIngredient(ingredient)) found.add(recipe);
        return found;
    }

    @Override
    public String toString() {
        String string = "";
        for(Recipe recipe: recipes) string += recipe + "\n";
        return string;
    }
    
}
