/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author admin
 */
public class Bird {
    private String name;
    private String nameLatin;
    private int times;
    
    public Bird(String name, String nameLatin) {
        this.name = name;
        this.nameLatin = nameLatin;
        this.times = 0;
    }

    public String getName() {
        return name;
    }

    public String getNameLatin() {
        return nameLatin;
    }
    
    public void observed() {
        times++;
    }   
    
    @Override
    public String toString() {
        return name + " (" +nameLatin + "): " + times + " observations";
    }
    
    
}
