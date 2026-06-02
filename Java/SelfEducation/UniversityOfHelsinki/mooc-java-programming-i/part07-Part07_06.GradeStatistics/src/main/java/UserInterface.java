import java.util.Scanner;
//import java.util.ArrayList
public class UserInterface {
    private Scanner scanner;
    private Grades grades;

    public UserInterface(Scanner scanner, Grades grades) {
        this.scanner = scanner;
        this.grades = grades;
    }
    
    public void start() {
        
        while(true) {
            int grade = Integer.valueOf(scanner.nextLine());
            if (grade == -1) break;
            grades.add(grade);
        }
        
        System.out.println("Point average (all): " + grades.averageTotal());
        System.out.println("Point average (passing): " + grades.averagePassing());
        System.out.println("Pass percentage: " + grades.percentagePassing());
        for(int i = 5; i >= 0; i--) {
            System.out.println(i + ": " + grades.gradeAsStars(i));
        }
        
    }
    
}
