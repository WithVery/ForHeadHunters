import java.util.ArrayList;

public class Pipe<T> {
    private ArrayList<T> pipe;

    public Pipe() {
        pipe = new ArrayList<>();
    }
    
    public void putIntoPipe(T value) {
        pipe.add(value);
    }
    
    public T takeFromPipe() {
        T element;
        if(pipe.size() > 0) {
            element = pipe.get(0);
            pipe.remove(0);
        } else {
            element = null;
        }
        return element;
    }
    
    public boolean isInPipe() {
        return pipe.size() > 0;
    }
    
}
