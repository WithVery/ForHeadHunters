package application;

import java.util.ArrayList;
import java.lang.IllegalStateException;
import java.util.List;

public class AverageSensor implements Sensor {
    private ArrayList<Sensor> sensors;
    private ArrayList<Integer> readings;

    public AverageSensor() {
        sensors = new ArrayList<>();
        readings = new ArrayList<>();
    }
    
    public void addSensor(Sensor toAdd) {
        sensors.add(toAdd);
    }
    
    @Override
    public boolean isOn() {
        return sensors.stream().map(sensor -> sensor.isOn()).allMatch(b->b);
    }
    
    @Override
    public void setOn() {
        for(Sensor sensor: sensors) sensor.setOn();
    }
    
    @Override
    public void setOff() {
        if(sensors.size() > 0) sensors.get(0).setOff();
    }

    @Override
    public int read() {
        if(sensors.size() == 0 || !isOn()) {
            throw new IllegalStateException("Is off or empty.");
        }
        int reading = (int)Math.floor(sensors.stream().mapToInt(sensor -> sensor.read()).average().getAsDouble());
        readings.add(reading);
        return reading;
    }
    
    public List<Integer> readings() {
        return readings;
    }
    
}
