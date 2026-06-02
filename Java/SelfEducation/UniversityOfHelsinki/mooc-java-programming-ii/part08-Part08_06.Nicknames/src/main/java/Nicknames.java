
import java.util.HashMap;

public class Nicknames {

    public static void main(String[] args) {
        // Do the operations required here!
        HashMap<String, String> namesMap = new HashMap<>();
        
        namesMap.put("matthew", "matt");
        namesMap.put("michael", "mix");
        namesMap.put("arthur", "artie");
        
        System.out.println(namesMap.get("matthew"));
    }

}
