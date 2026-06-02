
import java.util.ArrayList;
import java.util.Scanner;

public class PersonalInformationCollection {

    public static void main(String[] args) {
        // implement here your program that uses the PersonalInformation class

        ArrayList<PersonalInformation> infoCollection = new ArrayList<>();
        Scanner scanner = new Scanner(System.in);

        while(true) {
            String firstName = scanner.nextLine();
            if(firstName.equals("")) {
                break;
            }
            String familyName = scanner.nextLine();
            String id = scanner.nextLine();
            
            infoCollection.add(new PersonalInformation(firstName, familyName, id));
        }
        
        for(PersonalInformation info: infoCollection) {
            System.out.println(info.getFirstName() + " " + info.getLastName());
        }
    }
}
