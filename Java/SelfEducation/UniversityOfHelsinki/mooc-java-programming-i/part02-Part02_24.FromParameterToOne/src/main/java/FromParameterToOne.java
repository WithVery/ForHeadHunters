

public class FromParameterToOne {

    public static void main(String[] args) {
        printFromNumberToOne(5);
    }
    
    public static void printFromNumberToOne(int number) {
        for(int i = number; 0 < i; i--) {
            System.out.println(i);
        }
    }

}
