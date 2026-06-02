import java.util.ArrayList;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        
        // implement here the program that allows the user to enter 
        // book information and to examine them
        Scanner scanner = new Scanner(System.in);
        ArrayList<Book> books = new ArrayList<>();
        
        while(true) {
            System.out.println("Title: ");
            String name = scanner.nextLine();
            if(name.equals("")) {
                break;
            }
            
            System.out.println("Pages: ");
            Integer pages = Integer.valueOf(scanner.nextLine());
            
            System.out.println("Publication year: ");
            Integer year = Integer.valueOf(scanner.nextLine());
            
            books.add(new Book(name, pages, year));
        }
        
        System.out.println("What information will be printed?");
        String info = scanner.nextLine();
        
        if(info.equals("everything")) {
            for(Book book: books) {
                System.out.println(book);
            }
        }
        else if(info.equals("name")) {
            for(Book book: books) {
                System.out.println(book.getName());
            }
        }

    }
}
