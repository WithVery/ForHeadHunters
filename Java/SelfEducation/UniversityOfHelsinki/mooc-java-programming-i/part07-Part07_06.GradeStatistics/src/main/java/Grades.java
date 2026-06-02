import java.util.ArrayList;

public class Grades {
    private ArrayList<Integer> grades;

    public Grades() {
        grades = new ArrayList<>();
    }
    
    public void add(int grade) {
        if(0 <= grade && grade <= 100)
            grades.add(grade);
    }
    
    public double averageTotal() {
        if(grades.isEmpty()) return 0;
        double sum = 0;
        for(Integer grade: grades) sum += grade;
        return sum / grades.size();
    }
    
    public String averagePassing() {
        if(grades.isEmpty()) return "-";
        double sum = 0;
        int count = 0;
        for(Integer grade: grades) {
            if(50 <= grade) {
                sum += grade;
                count++;
            }
        }
        
        return count == 0 ? "-" : "" + (sum / count);
        
    }
    
    public double percentagePassing() {
        if(grades.isEmpty()) return 0;
        int count = 0;
        for(Integer grade: grades) {
            if(50 <= grade) count++;
        }
        return 100.0 * count / grades.size();
    }
    
    public String gradeAsStars(int gradeAsStar) {
        String stars = "";
        for(Integer grade: grades) {
            int val;
            if(grade < 50) val = 0;
            else if (grade < 60) val = 1;
            else if (grade < 70) val = 2;
            else if (grade < 80) val = 3;
            else if (grade < 90) val = 4;
            else val = 5;
            
            if (val == gradeAsStar) 
                stars += "*";
        }
        return stars;
    }
}
