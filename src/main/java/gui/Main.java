package gui;

import databaseConnections.DatabaseService;
import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import utilityClasses.TournamentShortInfo;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

public class Main extends Application implements EventHandler<ActionEvent> {
    public static void main(String[] args) {
        launch(args);
    }

    Button showTournamentsButton;
    Button showRankingListButton;
    Button insertionMode;
    Button selectDateForRanking;
    Button goBack;
    Button results;
    Button filter;
    Scene mainMenu, rankingScene, insertionScene, tournamentScene;

    @Override
    public void start(Stage stage) throws Exception {
        stage.setTitle("Archiwum CoGdzieKiedy?");

        /*VBox buttonsForMainMenu = new VBox();
        showTournamentsButton = new Button("Tournaments");
        showRankingListButton = new Button("Rankings");
        insertionMode = new Button("Insert data");
        buttonsForMainMenu.getChildren().addAll(showTournamentsButton,showRankingListButton, insertionMode);
        mainMenu = new Scene(buttonsForMainMenu,500,300);
        stage.setScene(mainMenu);*/
    TableColumn<TournamentShortInfo,String> name = new TableColumn<>("Name");
    name.setMinWidth(200);
    name.setCellValueFactory(new PropertyValueFactory<>("name"));
        TableColumn<TournamentShortInfo, LocalDate> date = new TableColumn<>("Date");
        name.setMinWidth(200);
        name.setCellValueFactory(new PropertyValueFactory<>("date"));
        TableColumn<TournamentShortInfo,String> city = new TableColumn<>("City");
        name.setMinWidth(200);
        name.setCellValueFactory(new PropertyValueFactory<>("city"));


        TableView<TournamentShortInfo> turnieje = new TableView<>();

        turnieje.setItems(QueryResultToListConverter.getTheListOfAllTournamentsSortedByDate());
        turnieje.getColumns().addAll(name,date,city);
        mainMenu = new Scene(turnieje,500,300);
        stage.setScene(mainMenu);
        stage.show();
    }


    @Override
    public void handle(ActionEvent actionEvent) {
        if(actionEvent.getSource() == showTournamentsButton) {

        }
        else if(actionEvent.getSource() == showRankingListButton) {

        } else if (actionEvent.getSource() == insertionMode) {

        }
    }
}
