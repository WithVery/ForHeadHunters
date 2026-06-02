package ticTacToe;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.control.Label;
import javafx.scene.control.Button;
import javafx.scene.Node;

public class TicTacToeApplication extends Application {
    private boolean isTic;
    private GridPane grid;
    
    private String getTicOrTac() {
        return isTic ? "X" : "O";
    }
    
    private String getTurnLabel() {
        return "Turn: " + getTicOrTac();
    }

    private Node getNodeFromGridPane(GridPane grid, int col, int row) {
        for (Node node : grid.getChildren()) {
            if (GridPane.getColumnIndex(node) == col && grid.getRowIndex(node) == row) {
                return node;
            }
        }
        return null;
    }    
    
    private boolean checkFinish() {
        String[][] matrix = new String[3][3];
        int[] rowO = new int[3];
        int[] rowX = new int[3];
        int[] columnO = new int[3];
        int[] columnX = new int[3];
        
        int[] diagO = new int[2];
        int[] diagX = new int[2];
        
        for(int c = 0; c < 3; c++) {
            for(int r = 0; r < 3; r++) {
                Button button = (Button)getNodeFromGridPane(grid, c, r);
                matrix[c][r] = button.getText();
                if(matrix[c][r].equals("X")) {
                    columnX[c] += 1;
                    if(columnX[c] == 3) {
                        return true;
                    }
                    rowX[r] += 1;
                    if(rowX[r] == 3) {
                        return true;
                    }
                    if(c == r) {
                        diagX[0] +=1;
                        if (diagX[0] == 3) {
                            return true;
                        }
                    }
                    if(c == (2 - r)) {
                        diagX[1] += 1;
                        if (diagX[1] == 3) {
                            return true;
                        }
                    }
                } else if(matrix[c][r].equals("O")) {
                    columnO[c] += 1;
                    if(columnO[c] == 3) {
                        return true;
                    }
                    rowO[r] += 1;
                    if(rowO[r] == 3) {
                        return true;
                    }
                    if(c == r) {
                        diagO[0] +=1;
                        if (diagO[0] == 3) {
                            return true;
                        }
                    }
                    if(c == (2 - r)) {
                        diagO[1] += 1;
                        if (diagO[1] == 3) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }
    
    @Override
    public void start(Stage window) {
        isTic = true;
        BorderPane layout = new BorderPane();
        
        Label turnLabel = new Label(getTurnLabel());
        layout.setTop(turnLabel);
        
        grid = new GridPane();
        for(int i = 0; i < 3; i++) {
            for(int j = 0; j < 3; j++) {
                Button button = new Button(" ");
                button.setOnMouseClicked((event) -> {
                    Button b = (Button)event.getSource();
                    String text = b.getText();
                    
                    if(text.isBlank()) {
                        b.setText(getTicOrTac());
                        isTic = !isTic;
                        if(checkFinish()) {
                            turnLabel.setText("The end!");
                        } else {
                            turnLabel.setText(getTurnLabel());
                        }
                    }
                    //button.getLabel();
                    //System.out.println();
                });
                grid.add(button, i, j);
            }
        }
        
        layout.setCenter(grid);
        
        
        Scene scene = new Scene(layout);
        window.setScene(scene);
        window.show();
    }

    public static void main(String[] args) {
//        System.out.println("Hello world!");
        launch(TicTacToeApplication.class);
    }

}
