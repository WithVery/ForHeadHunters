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

public class Suitcase {
    private ArrayList<Item> items;
    private int weightMax;
    
    public Suitcase(int weightMax) {
        items = new ArrayList<>();
        this.weightMax = weightMax; 
    }
    
    public void addItem(Item item) {
        if(totalWeight() + item.getWeight() <= weightMax)
            items.add(item);
    }
    
    @Override
    public String toString() {
        
        int size = items.size();
        String amount = size > 0 ? (""  + size) : "no";
        String ending = size == 1 ? "" : "s";
        
        return amount + "item" + ending + " (" + totalWeight() + " kg)";
    }
    
    public void printItems() {
        for(Item item: items) System.out.println(item);
    }

    public int totalWeight() {
        int weight = 0;
        for(Item item: items) { 
            weight += item.getWeight();
        }
        return weight;
    }

    public Item heaviestItem() {
        Item heaviest = null;
        if (0 < items.size()) {
            heaviest = items.get(0);
            for(Item item: items) {
                if (heaviest.getWeight() < item.getWeight()) heaviest = item;
            }
        }
        return heaviest;
    }
}
