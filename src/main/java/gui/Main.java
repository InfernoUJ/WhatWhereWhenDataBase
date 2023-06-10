package gui;

import databaseConnections.DatabaseService;
import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;
import utilityClasses.TournamentShortInfo;

import java.util.Date;
import java.util.List;

public class Main extends Application {
    public static void main(String[] args) {
        launch(args);
    }




    @Override
    public void start(Stage stage) throws Exception {
        stage.setTitle("Archiwum CoGdzieKiedy?");


    }


}
