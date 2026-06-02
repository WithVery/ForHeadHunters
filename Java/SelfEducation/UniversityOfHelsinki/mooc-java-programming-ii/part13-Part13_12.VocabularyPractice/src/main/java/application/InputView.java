package application;

import javafx.scene.Parent;
import javafx.scene.layout.GridPane;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.geometry.Pos;
import javafx.geometry.Insets;
import javafx.scene.control.Button;

public class InputView {
    private Dictionary dictionary;
    private GridPane pane;

    public InputView(Dictionary dictionary) {
        this.dictionary = dictionary;
        initView();
    }
    
    public Parent getView() {
        return pane;
    }
    
    public void initView() {
        pane = new GridPane();
        
        Label wordLabel = new Label("Word");
        TextField wordField = new TextField();
        Label translationLabel = new Label("Translation");
        TextField translationField = new TextField();
        
        pane.setAlignment(Pos.CENTER);
        pane.setVgap(10);
        pane.setHgap(10);
        pane.setPadding(new Insets(10,10,10,10));
        
        Button addButton = new Button("Add the word pair");
        
        pane.add(wordLabel, 0, 0);
        pane.add(wordField, 0, 1);
        pane.add(translationLabel, 0, 2);
        pane.add(translationField, 0, 3);
        pane.add(addButton, 0, 4);        

        addButton.setOnMouseClicked((event) -> {
            String word = wordField.getText();
            String translation = translationField.getText();
            
            dictionary.add(word, translation);
            wordField.clear();
            translationField.clear();
            
        });
    }
    
    
}
