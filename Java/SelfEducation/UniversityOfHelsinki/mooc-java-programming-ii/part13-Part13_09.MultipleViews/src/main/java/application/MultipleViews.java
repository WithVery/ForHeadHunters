package application;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.scene.layout.GridPane;

public class MultipleViews extends Application {

    @Override
    public void start(Stage window) {
        BorderPane layout1 = new BorderPane();
        Button button1 = new Button("To the second view!");
        layout1.setTop(new Label("First view!"));
        layout1.setCenter(button1);
        
        Scene scene1 = new Scene(layout1);
        
        VBox layout2 = new VBox();
        Button button2 = new Button("To the third view!");
        layout2.getChildren().add(button2);
        layout2.getChildren().add(new Label("Second view!"));
        
        Scene scene2 = new Scene(layout2);
        
        GridPane layout3 = new GridPane();
        Button button3 = new Button("To the first view!");
        
        layout3.add(new Label("Third view!"), 0, 0);
        layout3.add(button3, 1, 1);
        
        Scene scene3 = new Scene(layout3);
        
        button1.setOnAction((event) -> {window.setScene(scene2);});
        button2.setOnAction((event) -> {window.setScene(scene3);});
        button3.setOnAction((event) -> {window.setScene(scene1);});
        
        window.setScene(scene1);
        window.show();
        
    }
    
    public static void main(String[] args) {
        launch(MultipleViews.class);
    }

}
