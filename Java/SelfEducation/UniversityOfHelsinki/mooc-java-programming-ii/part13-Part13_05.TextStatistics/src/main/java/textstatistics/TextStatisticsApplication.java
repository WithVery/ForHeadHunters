package textstatistics;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.control.TextArea;
import javafx.scene.control.Label;


public class TextStatisticsApplication extends Application {

    @Override
    public void start(Stage window) {
        BorderPane layout = new BorderPane();
        TextArea textArea = new TextArea();
        HBox status = new HBox();
        
        status.getChildren().add(new Label("Letters: 0"));
        status.getChildren().add(new Label("Words: 0"));
        status.getChildren().add(new Label("The longest word is:"));
        
        layout.setCenter(textArea);
        layout.setBottom(status);
        
        Scene scene = new Scene(layout);
        window.setScene(scene);
        window.show();
        
    }

    public static void main(String[] args) {
        launch(TextStatisticsApplication.class);
    }

}
