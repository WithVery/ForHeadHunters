
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Scanner;

public class StoringRecords {

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);

        System.out.println("Filename:");
        String file = scan.nextLine();

        ArrayList<Person> records = readRecordsFromFile(file);
        System.out.println("Persons: " + records.size());
        System.out.println("Persons:");
        for (Person person : records) {
            System.out.println(person);

        }
    }

    public static ArrayList<Person> readRecordsFromFile(String file) {
        ArrayList<Person> persons = new ArrayList<>();
        
        try(Scanner reader = new Scanner(Paths.get(file))) {
            while(reader.hasNextLine()) {
                String line = reader.nextLine();
                String[] parts = line.split(",");
                persons.add(new Person(parts[0], Integer.valueOf(parts[1])));
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
        // Write here the code for reading from file
        // and printing the read records
        return persons;

    }
}
