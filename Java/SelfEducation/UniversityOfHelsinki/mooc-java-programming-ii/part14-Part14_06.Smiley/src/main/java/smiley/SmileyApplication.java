package smiley;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.BorderPane;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.paint.Color;

public class SmileyApplication extends Application{
    private final int steps = 8;
    
    @Override
    public void start(Stage window) {
        
        BorderPane layout = new BorderPane();
        
        Canvas canvas = new Canvas(640, 640);
        GraphicsContext painter = canvas.getGraphicsContext2D();
        layout.setCenter(canvas);
        
        int step = 640 / steps;
        
        painter.setFill(Color.BLACK);
        painter.fillRect(2 * step, step, step, step);
        painter.fillRect(5 * step, step, step, step);
        
        painter.fillRect(step, 4 * step, step, step);
        painter.fillRect(6 * step, 4 * step, step, step);
        
        painter.fillRect(2 * step, 5 * step, 4* step, step);

        Scene scene = new Scene(layout);
        window.setScene(scene);
        window.show();
    }

    public static void main(String[] args) {
        launch(SmileyApplication.class);
    }

}
