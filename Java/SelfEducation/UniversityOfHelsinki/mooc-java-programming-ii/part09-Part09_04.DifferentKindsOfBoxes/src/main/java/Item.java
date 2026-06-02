
public class Item {

    private String name;
    private int weight;

    public Item(String name, int weight) {
        this.name = name;
        this.weight = weight;
    }

    public Item(String name) {
        this(name, 0);
    }

    public String getName() {
        return name;
    }

    public int getWeight() {
        return weight;
    }
    

    @Override
    public boolean equals(Object obj) {
        if(obj == null || obj.getClass() != this.getClass()) return false;
        Item item = (Item) obj;
        return this == obj || name.equals(item.getName());
    }

    @Override
    public int hashCode() {
        return name.hashCode(); //To change body of generated methods, choose Tools | Templates.
    }
    
}
