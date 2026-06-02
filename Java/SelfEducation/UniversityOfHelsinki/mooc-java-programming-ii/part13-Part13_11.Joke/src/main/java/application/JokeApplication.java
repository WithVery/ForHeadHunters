package application;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;

public class JokeApplication extends Application {
    
    @Override
    public void start(Stage window) {
        BorderPane layout = new BorderPane();
        
        HBox menu = new HBox();
        Button button1 = new Button("Joke");
        Button button2 = new Button("Answer");
        Button button3 = new Button("Explanation");
        
        menu.getChildren().add(button1);
        menu.getChildren().add(button2);
        menu.getChildren().add(button3);
        
        layout.setTop(menu);
        
        StackPane pane1 = createPane("What do you call a bear with no teeth?");
        StackPane pane2 = createPane("A gummy bear.");
        StackPane pane3 = createPane("That's the way it is. (c)");
        
        button1.setOnAction((event)-> layout.setCenter(pane1));
        button2.setOnAction((event)-> layout.setCenter(pane2));
        button3.setOnAction((event)-> layout.setCenter(pane3));
        
        layout.setCenter(pane1);
        
        
        Scene scene = new Scene(layout);
                
        window.setScene(scene);
        window.show();
    }

    private StackPane createPane(String caption) {
        StackPane pane = new StackPane();
        pane.setPrefSize(300, 100);
        pane.getChildren().add( new Label(caption));
        return pane;
    }

    public static void main(String[] args) {
        launch(JokeApplication.class);
    }
}
