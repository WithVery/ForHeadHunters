import java.util.HashMap;
import java.util.Map;

public class BirdDB {
    private HashMap<String, Bird> birds;

    public BirdDB() {
        this.birds = new HashMap<>();
    }
    
    public void add(Bird bird) {
        if(!birds.containsKey(bird.getName())) {
            birds.put(bird.getName(), bird);
        }
    }

    public void observation(String name) {
        Bird bird = birds.get(name);
        if(bird != null) {
            bird.observed();
        } else {
            System.out.println("Not a bird!");
        }
    }
    
    public void print() {
        for(Map.Entry m: birds.entrySet()) { 
            System.out.println(m.getValue());
        }
    }
    
    public void print(String name) {
        Bird bird = birds.get(name);
        if(bird != null)
            System.out.println(bird);
    }
}
