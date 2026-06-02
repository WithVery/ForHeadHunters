public class Hideout<T> {
    
    private T element;

    public Hideout() {
    }
    
    public void putIntoHideout(T toHide) {
        if(element.equals(toHide)) {
            element = null;
        } else {
            element = toHide;
        }
    }
    
    public T takeFromHideout() {
        T takenElement = element;
        element = null;
        return takenElement;
    }
    
    public boolean isInHideout() {
        return element != null;
    }
}
