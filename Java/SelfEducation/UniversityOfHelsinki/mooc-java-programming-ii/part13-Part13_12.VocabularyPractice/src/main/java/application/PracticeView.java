package application;

import javafx.scene.Parent;
import javafx.scene.layout.GridPane;
import javafx.scene.control.Label;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.geometry.Pos;
import javafx.geometry.Insets;

public class PracticeView {
    private Dictionary dictionary;
    private String word;
//    private GridPane pane;

    public PracticeView(Dictionary dictionary) {
        this.dictionary = dictionary;
    }
    
    public Parent getView() {
        word = dictionary.getRandomWord();
        GridPane pane = new GridPane();
        Label instructionLabel = new Label("Translate the word '" + this.word + "'");
        TextField translationField = new TextField();        

        pane.setAlignment(Pos.CENTER);
        pane.setVgap(10);
        pane.setHgap(10);
        pane.setPadding(new Insets(10, 10, 10, 10));
        
        Button checkButton = new Button("Check");
        Label feedbackLabel = new Label();
        
        pane.add(instructionLabel, 0, 0);
        pane.add(translationField, 0, 1);
        pane.add(checkButton, 0, 2);
        pane.add(feedbackLabel, 0, 3);
        
        checkButton.setOnMouseClicked((event) -> {
            String translation = dictionary.get(word);
            if(translation.equals(translationField.getText())) {
                feedbackLabel.setText("Correct!");
            } else {
                feedbackLabel.setText("Incorrect! The translation fo the word '" + word + "' is '" + translation + "'.");
                return;
            }
            word = dictionary.getRandomWord();
            instructionLabel.setText("Translate the word '" + word + "'");
            translationField.clear();
        });
        return pane;
    }
    
    
}
