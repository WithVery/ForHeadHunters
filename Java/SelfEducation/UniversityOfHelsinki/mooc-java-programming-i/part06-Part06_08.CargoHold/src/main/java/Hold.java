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

public class Hold {
    private ArrayList<Suitcase> suitcases;
    private int maxWeight;
    
    public Hold(int maxWeight) {
        suitcases = new ArrayList<>();
        this.maxWeight = maxWeight;
    }
    
    public void addSuitcase(Suitcase suitcase) {
        if(totalWeight() + suitcase.totalWeight() <= maxWeight)
            suitcases.add(suitcase);
    }
    
    public int totalWeight() {
        int weight = 0;
        for(Suitcase suitcase: suitcases) weight += suitcase.totalWeight();
        return weight;
    }
    
    @Override
    public String toString() {
        return suitcases.size() + "suitcases (" + totalWeight() + " kg)";
    }
    
    public void printItems() {
        for(Suitcase suitcase: suitcases) suitcase.printItems();
    }
    
    
    
}
