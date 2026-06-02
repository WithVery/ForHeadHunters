package textstatistics;

import javafx.application.Application;
import static javafx.application.Application.launch;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.control.TextArea;
import javafx.scene.control.Label;
import java.util.Arrays;


public class TextStatisticsApplication extends Application {

    @Override
    public void start(Stage window) {
        BorderPane layout = new BorderPane();
        TextArea textArea = new TextArea();
        Label lettersLabel = new Label("Letters: 0");
        Label wordsLabel = new Label("Words: 0");
        Label longestLabel = new Label("The longest word is:");
        HBox status = new HBox();
        status.setSpacing(5);
        
        status.getChildren().add(lettersLabel);
        status.getChildren().add(wordsLabel);
        status.getChildren().add(longestLabel);
        
        textArea.textProperty().addListener((change, oldValue, newValue)-> {
            int characters = newValue.length();
            lettersLabel.setText("Letters: " + characters);
            String[] words = newValue.split(" ");
            wordsLabel.setText("Words: " + words.length);
            
            String longest = Arrays.stream(words)
                    .sorted((s1, s2) -> s2.length() - s1.length())
                    .findFirst().get();
            longestLabel.setText("The longest word is: " + longest);
            
        });
        
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
