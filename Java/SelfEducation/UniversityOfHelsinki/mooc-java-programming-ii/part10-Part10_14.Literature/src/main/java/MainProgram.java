import java.util.ArrayList;
import java.util.Collections;
import java.util.Scanner;
import java.util.Comparator;

public class MainProgram {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        ArrayList<Book> books = new ArrayList<>();
        
        while(true) {
            System.out.println("Input the name of the book, empty stops: ");
            String title = scanner.nextLine();
            if(title.isEmpty()) {
                break;
            }
            
            System.out.println("Input the age recommendation: ");
            String age = scanner.nextLine();
            if(age.isEmpty()) {
                break;
            }
            
            books.add(new Book(title, Integer.valueOf(age)));
        }
        
        Comparator<Book> comparator = Comparator.comparing(Book::getAge).thenComparing(Book::getTitle);
        
        Collections.sort(books, comparator);
        
        System.out.println(books.size() + " books in total.");
        
        System.out.println("Books:");
        
        for(Book book: books) System.out.println(book);
        
    }

    
    
}
