
import java.util.ArrayList;

public class SimpleCollection {

    private String name;
    private ArrayList<String> elements;

    public SimpleCollection(String name) {
        this.name = name;
        this.elements = new ArrayList<>();
    }

    public void add(String element) {
        this.elements.add(element);
    }

    public ArrayList<String> getElements() {
        return this.elements;
    }
    
    @Override
    public String toString() {
        String result;
        if(elements.isEmpty()) {
            result = "is empty.";
        }
        else {
            result = "has " + elements.size() + " element" + (elements.size() == 1?"":"s") + ":";
            for(String element: elements) {
                result += "\n" + element;
            }
        }
        return "The collection " + name + " " + result;
    }
    
}
