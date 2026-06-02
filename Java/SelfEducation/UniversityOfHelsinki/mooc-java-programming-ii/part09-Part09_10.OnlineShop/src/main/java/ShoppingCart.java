import java.util.Map;
import java.util.HashMap;

public class ShoppingCart {
    private Map<String, Item> items;

    public ShoppingCart() {
        items = new HashMap<>();
    }
    
    public void add(String product, int price) {
        if(items.containsKey(product)) {
            items.get(product).increaseQuantity();
        } else {
            items.put(product, new Item(product, 1, price));
        }
    }
    
    public int price() {
        int sum = 0;
        for(Item item: items.values()) sum += item.price();
        return sum;
    }
    
    public void print() {
        for(Item item: items.values()) System.out.println(item);
    }
}
