import java.util.ArrayList;


public class Herd implements Movable {
    private ArrayList<Movable> movables;

    public Herd() {
        movables = new ArrayList<>();
    }
    
    @Override
    public String toString() {
        String res = "";
        for(Movable movable: movables) res += movable.toString() + "\n";
        return res;
    }
    
    public void addToHerd(Movable movable) {
        movables.add(movable);
    }
    
    public void move(int dx, int dy) {
        for(Movable movable: movables) movable.move(dx, dy);
    }
}
