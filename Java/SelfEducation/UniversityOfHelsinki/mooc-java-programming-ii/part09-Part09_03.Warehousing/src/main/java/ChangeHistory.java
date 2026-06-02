import java.util.ArrayList;

public class ChangeHistory {
    private ArrayList<Double> statuses;
    
    public ChangeHistory() {
        statuses = new ArrayList<>();
    }
    
    public void add(double status) {
        statuses.add(status);
    }
    
    @Override
    public String toString() {
        return statuses.toString();
    }
    
    public double maxValue() {
        double maxValue = 0;
        for(Double status: statuses) if (maxValue < status) maxValue = status;
        return maxValue;
    }
    
    public double minValue() {
        if(statuses.isEmpty()) return 0;
        double minValue = statuses.get(0);
        for(Double status: statuses) if (minValue > status) minValue = status;
        return minValue;
    }
    
    public double average() {
        if(statuses.isEmpty()) return 0;
        double sum = 0;
        for(Double status: statuses) sum += status;
        return sum / statuses.size();
    }
    
    public void clear() {
        statuses.clear();
    }
    
    
}
