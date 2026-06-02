import java.lang.ArrayIndexOutOfBoundsException;

public class List<T> {
    private T[] values;
    private int firstFreeIdx;

    public List() {
        values = (T[]) new Object[10];
        firstFreeIdx = 0;
    }
    
    public void add(T value) {
        if(values.length == firstFreeIdx) {
            grow();
        }
        values[firstFreeIdx] = value;
        firstFreeIdx++;
    }
    
    private void grow() {
        int newLength = values.length * 3 / 2;
        T[] newValues = (T[]) new Object[newLength];
        for(int i = 0; i < values.length; i++) newValues[i] = values[i];
        values = newValues;
    }

    public boolean contains(T value) {
        return 0 <= indexOf(value);
    }
    
    public int indexOf(T value) {
        for(int i = 0; i < values.length; i++) 
            if (values.equals(value)) return i;
        return -1;
    }
    
    private void shiftFromIdx(int idx) {
        for(int i = idx; i < firstFreeIdx - 1; i++) {
            values[i] = values[i+1];
        }
        firstFreeIdx--;
    }
    
    public void remove(T value) {
        int idx = indexOf(value);
        if(0 <= idx) {
            shiftFromIdx(idx);
        }
    }
    
    public T value(int index) {
        if(0 <= index && index < firstFreeIdx) {
            return values[index];
        }
        else {
            throw new ArrayIndexOutOfBoundsException("Index " + index + " is out od bound!");
        }
    }
    
}
