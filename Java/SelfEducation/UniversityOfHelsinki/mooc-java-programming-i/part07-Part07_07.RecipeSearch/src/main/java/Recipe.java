/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author admin
 */

import java.util.ArrayList;

public class Recipe {
    private String name;
    private int time;
    private ArrayList<String> ingredients;
    
    //public Recipe(String name, int time, ArrayList<String> ingredients) {
    public Recipe(String name, int time) {
        this.name = name;
        this.time = time;
        this.ingredients = new ArrayList<>();
    }
    
    public String getName() {
        return name;
    }
    
    public int getTime() {
        return time;
    }
    
    public void addIngredient(String ingredient) {
        ingredients.add(ingredient);
    }
    
    public boolean containsIngredient(String ingredientSearched) {
        for(String ingredient: ingredients) if (ingredient.equals(ingredientSearched)) return true;
        return false;
    }
 
    @Override
    public String toString() {
        return name + ", cooking time: " + time;
    }
}

