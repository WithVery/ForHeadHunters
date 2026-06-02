package dictionary;

import java.util.HashMap;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.util.stream.Stream;
import java.io.PrintWriter;
import java.io.FileNotFoundException;

public class SaveableDictionary {
    private HashMap<String, String> dictTo;
    private HashMap<String, String> dictFrom;
    private String file;

    public SaveableDictionary() {
        this.dictTo = new HashMap<>();
        this.dictFrom = new HashMap<>();
    }

    public SaveableDictionary(String file) {
        this();
        this.file = file;
    }

    public void add(String word, String translation) {
        if(!dictTo.containsKey(word) && !dictFrom.containsKey(word)) {
            dictTo.put(word, translation);
            dictFrom.put(translation, word);
        }
    }
        
    public String translate(String word) {
        String s = dictTo.get(word);
        if(s == null) {
            s = dictFrom.get(word);
        }
        return s;
    }
    
    public void delete(String word) {
        String s = dictTo.remove(word);
        if(s == null) {
            s = dictFrom.remove(word);
            if(s!=null) dictTo.remove(s);
        } else {
            dictFrom.remove(s);
        }
    }
    
    public boolean load() {
        try(Stream<String> lines = Files.lines(Paths.get(file))) {
            dictTo.clear();
            dictFrom.clear();
            lines.forEach(line -> 
                { 
                    String words[] = line.split(":");
                    if(words.length > 1) {
                        dictTo.put(words[0], words[1]);
                        dictFrom.put(words[1], words[0]);
                    }
                }
            );
//        }
            return true;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }
    
    public boolean save() {
        try(PrintWriter printWriter = new PrintWriter(file)) {
            dictTo.forEach((word, translation)-> printWriter.println(word+":"+translation));
            return true;
        } catch (FileNotFoundException e) {
            System.out.println("File not found");
            return false;
        }
    }
}
