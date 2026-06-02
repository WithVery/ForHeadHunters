package application;

import java.lang.IllegalStateException;
import java.util.Random;

public class TemperatureSensor implements Sensor {
    private boolean isOn;
    private Random random;

    public TemperatureSensor() {
        isOn = false;
        random = new Random();
    }
    
    @Override
    public boolean isOn() {
        return isOn;
    }
    
    @Override
    public void setOn() {
        isOn = true;
    }
    
    @Override
    public void setOff() {
        isOn = false;
    }
    
    @Override
    public int read() {
        if(!isOn) {
            throw new IllegalStateException("The sensor is off!");
        } 
        
        return random.nextInt(61) - 30;
    }
    
    
}
