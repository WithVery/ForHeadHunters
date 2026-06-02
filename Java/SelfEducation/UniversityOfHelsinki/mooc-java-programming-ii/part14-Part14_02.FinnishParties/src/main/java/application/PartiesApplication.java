package application;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;
import java.util.ArrayList;
import java.util.HashMap;

public class PartiesApplication extends Application {

    @Override 
    public void start(Stage window) {
        NumberAxis xAxis = new NumberAxis();
        xAxis.setAutoRanging(false);
        NumberAxis yAxis = new NumberAxis();
        
        ArrayList<Integer> years = new ArrayList<>();
        
        LineChart<Number, Number> chart = new LineChart<>(xAxis, yAxis);
        
        try (Stream<String> lines = Files.lines(Paths.get("partiesdata.tsv"))) {
            lines.forEach(line -> {
                String[] values = line.split("\t");
                if(values[0].equals("Party")) {
                    int min = Integer.MAX_VALUE;
                    int max = Integer.MIN_VALUE;
                    for(int i = 1; i < values.length; i++) {
                        int cur = Integer.valueOf(values[i]);
                        min = Math.min(cur, min);
                        max = Math.max(cur, max);
                        years.add(cur);
                    };
                    xAxis.setLowerBound(min);
                    xAxis.setUpperBound(max);
                } else {
                    XYChart.Series series = new XYChart.Series();
                    series.setName(values[0]);
                    for(int i = 1; i < values.length; i++) {
                        if(!values[i].equals("-"))
                            series.getData().add(new XYChart.Data(years.get(i-1), Double.valueOf(values[i])));
                    }
                    chart.getData().add(series);
                }
            });
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
        
        Scene scene = new Scene(chart);
        window.setScene(scene);
        window.show();
    }
    
    public static void main(String[] args) {
        launch(PartiesApplication.class);
    }

}
