package title;

import javafx.application.Application;
import javafx.application.Application.Parameters;
import javafx.stage.Stage;

public class Main extends Application {

    @Override
    public void start(Stage window) {
        Parameters params = getParameters();
        window.setTitle(params.getNamed().get("Title"));
        window.show();
    }
    
    public static void main(String[] args) {
        Application.launch(Main.class, args[0]);
    }

}
