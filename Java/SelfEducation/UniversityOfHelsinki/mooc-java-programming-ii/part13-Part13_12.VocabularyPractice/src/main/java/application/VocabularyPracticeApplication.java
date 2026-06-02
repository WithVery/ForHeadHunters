package application;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;

public class VocabularyPracticeApplication extends Application {

    private Dictionary dict;
    
    @Override
    public void init() {
        dict = new Dictionary();
    }
    
    @Override
    public void start(Stage window) {
        
        InputView inputLayout = new InputView(dict);
        PracticeView practiceLayout = new PracticeView(dict);
        
        BorderPane layout = new BorderPane();
        
        HBox menu = new HBox();
        Button enterButton = new Button("Enter new words");
        Button practiceButton = new Button("Practice");        
        
        menu.getChildren().addAll(enterButton, practiceButton);
        enterButton.setOnAction((e) -> layout.setCenter(inputLayout.getView()));
        practiceButton.setOnAction((e) -> {
            layout.setCenter(practiceLayout.getView());
        });
        
        layout.setTop(menu);
        
        layout.setCenter(inputLayout.getView());
        
        Scene scene = new Scene(layout);
        window.setScene(scene);
        window.show();
    }

    public static void main(String[] args) {
        launch(VocabularyPracticeApplication.class);
    }
}
