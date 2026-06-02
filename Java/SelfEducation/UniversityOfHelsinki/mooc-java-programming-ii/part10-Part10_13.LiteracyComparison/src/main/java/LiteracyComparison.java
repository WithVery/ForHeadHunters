
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class LiteracyComparison {
    
    public static void main(String[] args) {
        try {
            Files.lines(Paths.get("literacy.csv")).map(line -> line.split(","))
                .sorted((p1, p2)-> {
                    double d1 = Double.valueOf(p1[5]);
                    double d2 = Double.valueOf(p2[5]);
                    return (d1 < d2) ? -1 : (d1 == d2) ? 0 : 1;
                }).forEach(parts -> System.out.println(parts[3] + " (" + parts[4] + "), " + parts[2].replace(" (%)", "").trim() + ", " + parts[5]));
//            List<String> lines = Files.lines(Paths.get("literacy.csv")).map(line -> line.split(","))
//                .sorted((p1, p2)-> {
//                    double d1 = Double.valueOf(p1[5]);
//                    double d2 = Double.valueOf(p2[5]);
//                    return (d1 < d2) ? -1 : (d1 == d2) ? 0 : 1;
//                }).map(parts -> parts[3] + " (" + parts[4] + "), " + parts[2].replace(" (%)", "").trim() + ", " + parts[5])
//                .collect(Collectors.toList());
//            
//            String lineOrig = lines.get(0).trim();
//            String line = "Niger (2015), female, 11.01572";
//            
//            System.out.println(lineOrig);
//            System.out.println(line);
//            System.out.println(lineOrig.equals(line));
            
            
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
