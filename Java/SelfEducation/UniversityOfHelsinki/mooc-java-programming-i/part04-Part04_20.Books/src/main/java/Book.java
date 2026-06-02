/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author admin
 */
public class Book {
    private String name;
    private int pages;
    private int year;
    
    public Book(String initialName, int initialPages, int initialYear) {
        this.name = initialName;
        this.pages = initialPages;
        this.year = initialYear;
    }
    
    public String toString() {
        return name + ", " + pages + " pages, " + year;
    }
    
    public String getName() {
        return name;
    }
    
}
