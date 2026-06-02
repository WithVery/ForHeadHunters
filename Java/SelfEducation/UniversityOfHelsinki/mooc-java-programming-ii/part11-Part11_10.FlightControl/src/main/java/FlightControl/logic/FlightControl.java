package FlightControl.logic;

import java.util.Collection;
import java.util.HashMap;
import FlightControl.domain.*;

public class FlightControl {
    private HashMap<String, Airplane> airplanes;
    private HashMap<String, Place> places;
    private HashMap<String, Flight> flights;

    public FlightControl() {
        this.airplanes = new HashMap<>();
        this.places = new HashMap<>();
        this.flights  = new HashMap<>();
    }
    
    public void addAirplane(String ID, int capacity) {
        airplanes.put(ID, new Airplane(ID, capacity));
    }
    
    public void addFlight(Airplane plane, String departureID, String destinationID) {
            places.putIfAbsent(departureID, new Place(departureID));
            places.putIfAbsent(destinationID, new Place(destinationID));
            
            Flight flight = new Flight(plane, places.get(departureID), places.get(destinationID));
            
            flights.put(flight.toString(), flight);
    }
    
    public Collection<Airplane> getAirplanes() {
        return airplanes.values();
    }
    
    public Collection<Flight> getFlights() {
        return flights.values();
    }
    
    public Airplane getAirplane(String ID) {
        return airplanes.get(ID);
    }
    
}
