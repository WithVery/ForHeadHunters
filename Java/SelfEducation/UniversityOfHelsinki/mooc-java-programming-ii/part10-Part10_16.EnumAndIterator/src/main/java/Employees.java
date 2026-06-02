import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;

public class Employees {
    private ArrayList<Person> persons;

    public Employees() {
        persons = new ArrayList<>();
    }
    
    public void add(Person personToAdd) {
        persons.add(personToAdd);
    }
    
    public void add(List<Person> peopleToAdd) {
        persons.addAll(peopleToAdd);
    }
    
    public void print() {
        Iterator<Person> iterator  = persons.iterator();
        
        while(iterator.hasNext()) {
            System.out.println(iterator.next());
        }
//        for(Person person: persons) {
//            System.out.println(person);
//        }
    }
    
    public void print(Education education) {
        Iterator<Person> iterator = persons.iterator();
        while(iterator.hasNext()) {
            Person person = iterator.next();
            if (person.getEducation() == education) System.out.println(person);
        }
//        for(Person person: persons) {
//            if (person.getEducation() == education) System.out.println(person);
//        }
    }
    
    public void fire(Education education) {
        Iterator<Person> iterator = persons.iterator();
        while(iterator.hasNext()) {
            Person person = iterator.next();
            if(person.getEducation() == education) {
                iterator.remove();
            }
        }
    }
}
