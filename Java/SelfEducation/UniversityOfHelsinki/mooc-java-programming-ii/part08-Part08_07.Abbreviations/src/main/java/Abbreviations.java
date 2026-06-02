import java.util.HashMap;

public class Abbreviations {
    HashMap<String, String> abbreviations;
    
    public Abbreviations() {
        abbreviations = new HashMap<>();
    }
    
    public void addAbbreviation(String abbreviation, String explanation) {
        if(abbreviation == null || abbreviation.isEmpty()) return;
        if(abbreviations.containsKey(abbreviation)) {
            System.out.println(abbreviation + " is already on the list.");
        } else {
            abbreviations.put(abbreviation, explanation);
        }
    }
  
    public boolean hasAbbreviation(String abbreviation) {
        if(abbreviation == null || abbreviation.isEmpty()) return false;
        
        return abbreviations.containsKey(abbreviation);
    }
    
    public String findExplanationFor(String abbreviation) {
        if(abbreviation == null || abbreviation.isEmpty()) {
            return null;
        } else {
            return abbreviations.get(abbreviation);
        }
    }
//    public static
}
