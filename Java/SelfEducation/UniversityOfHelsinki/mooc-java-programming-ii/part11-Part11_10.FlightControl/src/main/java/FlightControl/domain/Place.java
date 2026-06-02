package FlightControl.domain;

public class Place {
    private String id;

    public Place(String id) {
        this.id = id;
    }
    
    @Override
    public String toString() {
        return this.id;
    }
    
}
