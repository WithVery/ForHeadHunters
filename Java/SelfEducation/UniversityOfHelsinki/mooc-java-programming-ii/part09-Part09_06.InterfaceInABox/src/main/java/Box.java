import java.util.ArrayList;

public class Box implements Packable {
    private ArrayList<Packable> articles;
    private double  capacity;

    public Box(double capacity) {
        this.capacity = capacity;
        this.articles = new ArrayList<>();
    }
    
    public double weight() {
        double weight = 0;
        for(Packable article: articles) weight += article.weight();
        return weight;
    }
    
    public void add(Packable item) {
        if(weight() + item.weight() <= capacity) articles.add(item);
    }
    
    @Override
    public String toString() {
        return "Box: " + articles.size() + " items, total weight " + weight() + " kg";
    }
    
}
