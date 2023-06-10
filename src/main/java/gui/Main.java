package gui;

import databaseConnections.DatabaseService;
import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.Label;
import javafx.scene.control.TableView;
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
        TableView turnieje = new TableView<>();


    }

    ObservableList<TournamentShortInfo> getTheListOfAllTournamentsSortedByDate() {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getAllTournamentsWithDatesAndCitySortedByDate();
        ObservableList<TournamentShortInfo> tournaments = FXCollections.observableArrayList();
        for(Object[] row : shortInfo) {
            TournamentShortInfo temp = new TournamentShortInfo();
            temp.setName((String)row[0]);
            temp.setDate((Date)row[1]);
            temp.setCity((String)row[2]);
            tournaments.add(temp);
        }


        return tournaments;
    }
}
