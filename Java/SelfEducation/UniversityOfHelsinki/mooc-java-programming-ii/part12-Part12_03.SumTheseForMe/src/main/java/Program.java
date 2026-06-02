
import java.util.Scanner;

public class Program {

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        // test your method here

    }

    public static int sum(int[] array, int fromWhere, int toWhere, int smallest, int largest) {
        int result = 0;
        for(int i = Math.max(0, fromWhere); i < Math.min(array.length, toWhere); i++) {
            if(smallest <= array[i] && array[i]< largest) result += array[i];
        }
        return result;
    }
}
