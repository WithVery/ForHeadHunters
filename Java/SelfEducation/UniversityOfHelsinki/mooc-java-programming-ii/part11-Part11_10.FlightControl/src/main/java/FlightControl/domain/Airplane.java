package FlightControl.domain;

public class Airplane {
    private String id;
    private int capacity;

    public Airplane(String id, int capacity) {
        this.id = id;
        this.capacity = capacity;
    }

    public String getId() {
        return id;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
    
    @Override
    public String toString() {
        return this.id + " (" + this.capacity + " capacity)";
    }
    
}
