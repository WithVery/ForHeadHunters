import java.util.HashMap;
import java.util.ArrayList;
import java.util.Map;

public class StorageFacility {
    private HashMap<String, ArrayList<String>> units;
    

    public StorageFacility() {
        units = new HashMap<>();
    }
    
    public void add(String unit, String item) {
        units.putIfAbsent(unit, new ArrayList<>());
        units.get(unit).add(item);
    }
    
    public ArrayList<String> contents(String storageUnit) {
        return units.getOrDefault(storageUnit, new ArrayList<>());
    }
    
    public void remove(String storageUnit, String item) {
        ArrayList<String> items = units.get(storageUnit);
        if(items != null && items.contains(item))
            items.remove(item);
    }
    
    public ArrayList<String> storageUnits() {
        ArrayList<String> result = new ArrayList<>();
        for(Map.Entry<String, ArrayList<String>> unit: units.entrySet()) {
            if(0 < unit.getValue().size()) 
                result.add(unit.getKey());
        }
        return result;
    }

//    public ArrayList<String> stiorageUnits() {
//        ArrayList<String> result = new ArrayList<>();
//        for(String unit: units.keySet()) {
//            if(0 < this.contents(unit).size()) {
//                result.add(unit);
//            }
//        }
//        return result;
//    }
}
