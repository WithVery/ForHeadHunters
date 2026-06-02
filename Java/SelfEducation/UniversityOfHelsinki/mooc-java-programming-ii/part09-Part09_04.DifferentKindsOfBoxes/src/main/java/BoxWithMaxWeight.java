import java.util.ArrayList;

public class BoxWithMaxWeight extends Box {
    private int capacity;
    private ArrayList<Item> items;

    public BoxWithMaxWeight(int capacity) {
        this.capacity = capacity;
        this.items = new ArrayList<>();
    }
    
    
    
    @Override
    public void add(Item item) {
        int amount = 0;
        for(Item curItem: items) amount += curItem.getWeight();
        if(amount + item.getWeight() <= capacity) items.add(item);
    }

    @Override
    public boolean isInBox(Item item) {
        return items.contains(item);
    }
}
