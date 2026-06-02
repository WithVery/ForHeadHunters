
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Scanner;

public class SportStatistics {

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        
        System.out.println("File:");
        String file = scan.nextLine();
        System.out.println("Team:");
        String team = scan.nextLine();
        
        try (Scanner reader = new Scanner(Paths.get(file))) {
            int games = 0;
            int wins = 0;
            int losses = 0;
            
            while(reader.hasNextLine()) {
                String line = reader.nextLine();
                String[] parts = line.split(",");
                Integer score1 = Integer.valueOf(parts[2]);
                Integer score2 = Integer.valueOf(parts[3]);
                if(team.equals(parts[0])) {
                    games++;
                    if(score1>score2) {
                        wins++;
                    } else {
                        losses++;
                    }
                } else if(team.equals(parts[1])) {
                    games++;
                    if(score1<score2) {
                        wins++;
                    } else {
                        losses++;
                    }
                }
            }
            System.out.println("Games: " + games);
            System.out.println("Wins: " + wins);
            System.out.println("Losses: " + losses);
            
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

}
