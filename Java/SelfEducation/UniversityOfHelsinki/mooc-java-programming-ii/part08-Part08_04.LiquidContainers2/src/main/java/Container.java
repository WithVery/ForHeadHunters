/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author admin
 */
public class Container {
    private int amount = 0;
    private static final int CAPACITY = 100;

    public Container() {
        amount = 0;
    }
    
    public void add(int amount) {
        if(amount > 0) {
            this.amount += amount;
            if(this.amount > CAPACITY) this.amount = CAPACITY;
        }
    }
    
    public void remove(int amount) {
        if(amount > 0) {
            this.amount -= amount;
            if(this.amount < 0) this.amount = 0;
        }
    }
    
    public int contains() {
        return this.amount;
    }
    
    @Override
    public String toString() {
        return amount + "/" + CAPACITY;
    }
    
}
