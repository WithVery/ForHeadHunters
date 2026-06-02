public class Program {

    public static void main(String[] args) {
        // Test your method here
    }

    public static String arrayAsString(int[][] array) {
        StringBuilder builder = new StringBuilder();
        for(int i = 0; i <array.length; i++) {
            for(int j = 0; j < array[i].length; j++) {
                builder.append(array[i][j]);
            }
            builder.append("\n");
        }
        return builder.toString();
    }
}
