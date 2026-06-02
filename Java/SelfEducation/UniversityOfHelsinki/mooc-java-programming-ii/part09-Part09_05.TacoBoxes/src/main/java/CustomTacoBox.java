public class CustomTacoBox implements TacoBox{
    private int tacos;

    public CustomTacoBox(int tacos) {
        this.tacos = tacos;
    }
    
    public int tacosRemaining() {
        return tacos;
    }
    
    public void eat() {
        if (tacos > 0) tacos--;
    }
}
