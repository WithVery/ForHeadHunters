package application;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;

public class SavingsCalculatorApplication extends Application {

    private LineChart<Number, Number> chart;
    private XYChart.Series savings;
    private XYChart.Series savTotal;

    private void setSliderLabelValue(Label label, double value) {
        label.setText(String.format("%.0f", value));
    }
    
    private void fillSavingSeries(double value, double interest) {
        savings.getData().clear();
        savTotal.getData().clear();
        double sum = 0;
        double withInterest = 0;
        savings.getData().add(new XYChart.Data(0, sum));
        savTotal.getData().add(new XYChart.Data(0, withInterest));
        for(int i = 1; i < 31; i++) {
            sum += value*12;
            withInterest = (withInterest + value*12) * (1 + interest /100);
            savings.getData().add(new XYChart.Data(i, sum));
            savTotal.getData().add(new XYChart.Data(i, withInterest));
        }
    }
    
    @Override
    public void start(Stage window) {

        NumberAxis xAxis = new NumberAxis(0, 30, 1);
        NumberAxis yAxis = new NumberAxis();
        
        chart = new LineChart<>(xAxis, yAxis);
        chart.setLegendVisible(false);
        savings = new XYChart.Series();
        savTotal = new XYChart.Series();
        chart.getData().add(savings);
        chart.getData().add(savTotal);
        
        BorderPane layout = new BorderPane();
        
        VBox menu = new VBox(8);
        
        BorderPane menuMonths = new BorderPane();
        Label monthsLabel = new Label("Monthly savings");
        Slider monthsSlider = new Slider(25, 250, 5);        
        monthsSlider.setBlockIncrement(1.0);
        
        monthsSlider.setShowTickMarks(true);
        monthsSlider.setShowTickLabels(true);
        Double monthsValue = monthsSlider.getValue();
        Label monthsSliderLabel = new Label();
        menuMonths.setLeft(monthsLabel);
        menuMonths.setCenter(monthsSlider);
        menuMonths.setRight(monthsSliderLabel);
        setSliderLabelValue(monthsSliderLabel, monthsValue);
        menu.getChildren().add(menuMonths);
        
        BorderPane menuInterest = new BorderPane();
        Label interestLabel = new Label("Yearly interest rate");
        Slider interestSlider = new Slider(0, 10, 0.01);        
        interestSlider.setBlockIncrement(1.0);
        interestSlider.setShowTickMarks(true);
        interestSlider.setShowTickLabels(true);
        Double interestValue = interestSlider.getValue();
        Label interestSliderLabel = new Label();
        
        menuInterest.setLeft(interestLabel);
        menuInterest.setCenter(interestSlider);
        menuInterest.setRight(interestSliderLabel);
        
        setSliderLabelValue(interestSliderLabel, interestValue);
        fillSavingSeries(monthsValue, interestValue);
        
        menu.getChildren().add(menuInterest);
        
        monthsSlider.valueProperty().addListener((observable, oldValue, newValue) -> {
            setSliderLabelValue(monthsSliderLabel, newValue.doubleValue());
            fillSavingSeries(newValue.doubleValue(), interestSlider.getValue());
        });        

        interestSlider.valueProperty().addListener((observable, oldValue, newValue) -> {
            setSliderLabelValue(interestSliderLabel, newValue.doubleValue());
            fillSavingSeries(monthsSlider.getValue(), newValue.doubleValue() );
        });        

        layout.setTop(menu);
        layout.setCenter(chart);
        
        Scene scene = new Scene(layout);
        
        window.setScene(scene);
        window.show();
    }
    public static void main(String[] args) {
        launch(SavingsCalculatorApplication.class);
    }

}
