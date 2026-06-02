package application;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.control.Label;

public class GreeterApplication extends Application {

    @Override
    public void start(Stage window) {
        VBox layout1 = new VBox();
        Button button = new Button("Start");
        TextField textField = new TextField();
        
        layout1.getChildren().add(textField);
        layout1.getChildren().add(button);
        
        Scene scene1 = new Scene(layout1);

        VBox layout2 = new VBox();
        Label label = new Label();
        
        layout2.getChildren().add(label);
        
        Scene scene2 = new Scene(layout2);
        

        button.setOnAction((event) -> {
            label.setText("Welcome " + textField.getText() + "!");
            window.setScene(scene2);
        });
        
        window.setScene(scene1);
        window.show();
        
    }

    public static void main(String[] args) {
        launch(GreeterApplication.class);
    }
}
