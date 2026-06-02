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

public class Stack {
    private ArrayList<String> stack;

    public Stack() {
        stack = new ArrayList<>();
    }
    
    public boolean isEmpty() {
        return stack.size() == 0;
    }
    
    public void add(String value) {
        stack.add(value);
    }
    
    public ArrayList<String> values() {
        return new ArrayList<String>(stack);
    }
    
    public String take() {
        int idx = stack.size() - 1;
        String value = stack.get(idx);
        stack.remove(idx);
        return value;
    }
}
