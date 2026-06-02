/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author admin
 */

public class Fitbyte {
    private int age;
    private int restingHeartRate;
    
    public Fitbyte(int age, int restingHeartRate) {
        this.age = age;
        this.restingHeartRate = restingHeartRate;
    }
    
    private double getMaximumHeartRate() {
        return 206.3 - (0.711 * age);
    }
    
    public double targetHeartRate(double percentageOfMaximum) {
        return (getMaximumHeartRate()-restingHeartRate) * percentageOfMaximum + restingHeartRate;
    }
            
}
