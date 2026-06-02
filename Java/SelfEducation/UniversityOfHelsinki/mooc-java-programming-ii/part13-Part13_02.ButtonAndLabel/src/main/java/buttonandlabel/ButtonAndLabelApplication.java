package buttonandlabel;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.FlowPane;
import javafx.stage.Stage;

public class ButtonAndLabelApplication extends Application{

    @Override
    public void start(Stage window) {
        Button button = new Button("This is a button");
        Label label = new Label("Text element");
        
        FlowPane pane = new FlowPane();
        pane.getChildren().add(label);
        pane.getChildren().add(button);
        
        Scene scene = new Scene(pane);
        
        window.setScene(scene);
        window.show();
        
    }

    public static void main(String[] args) {
        launch(ButtonAndLabelApplication.class);
    }

}
