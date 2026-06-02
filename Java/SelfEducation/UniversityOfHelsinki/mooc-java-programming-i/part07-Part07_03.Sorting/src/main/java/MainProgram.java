
public class MainProgram {

    public static void main(String[] args) {
        // write your test code here
        int[] array = {3, 1, 5, 99, 3, 12};
    }
    
    public static int smallest(int[] array) {
        int smallest = array[0];
        for(int i = 1; i < array.length; i++) if(smallest > array[i]) smallest = array[i];
        return smallest;
    }
    
    public static int indexOfSmallest(int[] array) {
        return indexOfSmallestFrom(array, 0);
    }
    
    public static int indexOfSmallestFrom(int[] array, int startIndex) {
        int smallest = array[startIndex];
        int idx = startIndex;
        
        for(int i = startIndex + 1; i < array.length; i++) {
            if(smallest > array[i]) {
                smallest = array[i];
                idx = i;
            }
        }
        return idx;
    }
    
    public static void swap(int[] array, int index1, int index2) {
      int tmp = array[index1];
      array[index1] = array[index2];
      array[index2] = tmp;
    }

    public static void sort(int[] array) {
        for (int i = 0; i < array.length; i++) {
            int j = indexOfSmallestFrom(array, i);
            if (j != i) {
                swap(array, i, j);
            }
        }
    }
}
