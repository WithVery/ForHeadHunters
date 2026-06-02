
public class MagicSquareFactory {

    public MagicSquare createMagicSquare(int size) {

        MagicSquare square = new MagicSquare(size);

        // implement the creation of a magic square with the Siamese method algorithm here
        int x = square.getWidth() / 2;
        int xMax = square.getWidth() - 1;
        int y = 0;
        int yMax = square.getHeight() - 1;
        int count = 0;
        int maxCount = (xMax + 1) * (yMax + 1);
        int cur = 1;
        
        do {
            square.placeValue(x, y, cur++);
            if(cur > maxCount) break;
            int newY = y - 1;
            if (newY < 0) newY = yMax;
            int newX = x + 1;
            if (xMax < newX) newX = 0;
            if(square.readValue(newX, newY) != 0) {
                newY = y + 1;
                if (yMax < newY) newY = 0;
                newX = x;
            }
            x = newX;
            y = newY;
        } while(cur<=maxCount);
        
        return square;
    }

}
