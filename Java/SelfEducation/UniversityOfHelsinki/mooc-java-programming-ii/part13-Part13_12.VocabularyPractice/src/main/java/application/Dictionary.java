package application;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Random;


public class Dictionary {
    private List<String> words;
    private Map<String, String> translations;
    
    public Dictionary() {
        words = new ArrayList<>();
        translations = new HashMap<>();
    }
    
    public String get(String word) {
        return translations.get(word);
    }
    
    public void add(String word, String translation) {
        if(!translations.containsKey(word)) {
            words.add(word);
        }
        
        translations.put(word, translation);
    }


    public String getRandomWord() {
        if(words.isEmpty()) {
            return "";
        } else {
            Random random = new Random();
            return words.get(random.nextInt(words.size()));
        }
    }
}
