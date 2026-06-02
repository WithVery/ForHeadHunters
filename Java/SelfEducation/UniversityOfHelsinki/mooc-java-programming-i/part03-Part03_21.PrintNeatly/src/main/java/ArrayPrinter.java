
public class ArrayPrinter {

    public static void main(String[] args) {
        // You can test your method here
        int[] array = {5, 1, 3, 4, 2};
        int[] array1 = new int[0];
        printNeatly(array);
    }

    public static void printNeatly(int[] array) {
        // Write some code in here
        if(array.length > 0) {
            System.out.print(array[0]);
        }
        for(int i = 1; i < array.length; i++) {
            System.out.print(", " + array[i]);
        }
    }
}
