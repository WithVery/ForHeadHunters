public class Student extends Person {
    private int credits;

    public Student(String name, String address) {
        super(name, address);
        credits = 0;
    }
    
    public void study() {
        credits++;
    }
    
    public int credits() {
        return credits;
    }

    @Override
    public String toString() {
        return super.toString() + "\n  " + "Study credits " + credits;
    }
}
