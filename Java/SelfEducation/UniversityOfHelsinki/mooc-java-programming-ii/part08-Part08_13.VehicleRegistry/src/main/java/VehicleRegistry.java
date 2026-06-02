import java.util.HashMap;
import java.util.ArrayList;

public class VehicleRegistry {
    
    private HashMap<LicensePlate, String> owners;

    public VehicleRegistry() {
        owners = new HashMap<>();
    }

    public boolean add(LicensePlate plate, String owner) {
        if(owners.containsKey(plate)) {
            return false;
        } else {
            owners.put(plate, owner);
            return true;
        }
    }
    
    public String get(LicensePlate plate) {
        return owners.get(plate);
    }
    
    public boolean remove(LicensePlate plate) {
        if(owners.containsKey(plate)) {
            owners.remove(plate);
            return true;
        } else {
            return false;
        }
    }
    
    public void printLicensePlates() {
        for(LicensePlate plate: owners.keySet()) {
            System.out.println(plate);
        }
    }
    
    public void printOwners() {
        ArrayList<String> ownersPrinted = new ArrayList<>();
        for(String owner: owners.values()) {
            if(!ownersPrinted.contains(owner)) {
                System.out.println(owner);
                ownersPrinted.add(owner);
            }
        }
    }
    
}
