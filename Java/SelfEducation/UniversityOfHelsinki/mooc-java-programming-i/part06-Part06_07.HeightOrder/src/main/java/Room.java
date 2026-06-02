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

public class Room {
    private ArrayList<Person> persons;

    public Room() {
        persons = new ArrayList<>();
    }
    
    public void add(Person person) {
        persons.add(person);
    }
    
    public boolean isEmpty() {
        return persons.size() == 0;
    }
    
    public ArrayList<Person> getPersons() {
        return this.persons;
    }
    
    public Person shortest() {
        Person shortest = null;
        if(0 < persons.size()) {
            shortest = persons.get(0);
            for(Person person: persons) {
                if(person.getHeight() < shortest.getHeight()) shortest = person;
            }
        }
        return shortest;
    }
    
    public Person take() {
        Person person = shortest();
        persons.remove(person);
        return person;
    }
}
