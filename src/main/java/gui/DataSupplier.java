package gui;

import databaseConnections.DatabaseService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.StackPane;
import utilityClasses.PersonInfo;

import utilityClasses.TournamentShortInfo;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

public class DataSupplier {
    public static TableView<TournamentShortInfo> getAllTournaments() {
        TableView<TournamentShortInfo> turnieje;

        TableColumn<TournamentShortInfo,String> name = new TableColumn<>("Name");
        name.setMinWidth(200);
        name.setCellValueFactory(new PropertyValueFactory<>("name"));

        TableColumn<TournamentShortInfo,LocalDate> date= new TableColumn<>("Date");
        date.setMinWidth(100);
        date.setCellValueFactory(new PropertyValueFactory<>("date"));
        TableColumn<TournamentShortInfo,String> city = new TableColumn<>("City");
        city.setMinWidth(100);
        city.setCellValueFactory(new PropertyValueFactory<>("city"));
        turnieje = new TableView<>();
        turnieje.setItems(QueryResultToListConverter.getTheListOfAllTournamentsSortedByDate());
        turnieje.getColumns().addAll(name,date,city);
        return turnieje;
    }

    public static TableView<PersonInfo> getRankingsInDate(LocalDate dateOfTheList) {
        TableView<PersonInfo> rankingi;

        TableColumn<PersonInfo,String> surname = new TableColumn<>("Surname");
        surname.setMinWidth(200);
        surname.setCellValueFactory(new PropertyValueFactory<>("playerSurname"));

        TableColumn<PersonInfo,String> name= new TableColumn<>("Name");
        name.setMinWidth(100);
        name.setCellValueFactory(new PropertyValueFactory<>("playerName"));
        TableColumn<PersonInfo,Integer> ranking = new TableColumn<>("Ranking");
        ranking.setMinWidth(100);
        ranking.setCellValueFactory(new PropertyValueFactory<>("rating"));
        rankingi = new TableView<>();
        rankingi.setItems(QueryResultToListConverter.getAllRankingsInPeriod(dateOfTheList));
        rankingi.getColumns().addAll(surname,name,ranking);
        return rankingi;
    }


    public static TableView<TournamentShortInfo> getTournamentsInPeriod(LocalDate begin, LocalDate end) {
        if(end.isBefore(begin)) {
            throw new IllegalArgumentException("incorrect Dates");
        }
        TableView<TournamentShortInfo> turnieje;

        TableColumn<TournamentShortInfo,String> name = new TableColumn<>("Name");
        name.setMinWidth(200);
        name.setCellValueFactory(new PropertyValueFactory<>("name"));

        TableColumn<TournamentShortInfo,String> date= new TableColumn<>("Date");
        date.setMinWidth(100);
        date.setCellValueFactory(new PropertyValueFactory<>("date"));
        TableColumn<TournamentShortInfo,String> city = new TableColumn<>("City");
        city.setMinWidth(100);
        city.setCellValueFactory(new PropertyValueFactory<>("city"));
        turnieje = new TableView<>();
        turnieje.setItems(QueryResultToListConverter.getTheListOfAllTournamentsInPeriod(begin,end));
        turnieje.getColumns().addAll(name,date,city);
        return turnieje;
    }
    public static TableView<TournamentShortInfo> getTournamentsInCity(String town) {

        TableView<TournamentShortInfo> turnieje;

        TableColumn<TournamentShortInfo,String> name = new TableColumn<>("Name");
        name.setMinWidth(200);
        name.setCellValueFactory(new PropertyValueFactory<>("name"));

        TableColumn<TournamentShortInfo,String> date= new TableColumn<>("Date");
        date.setMinWidth(100);
        date.setCellValueFactory(new PropertyValueFactory<>("date"));
        TableColumn<TournamentShortInfo,String> city = new TableColumn<>("City");
        city.setMinWidth(100);
        city.setCellValueFactory(new PropertyValueFactory<>("city"));
        turnieje = new TableView<>();
        turnieje.setItems(QueryResultToListConverter.getTheListOfAllTournamentsInCity(town));
        turnieje.getColumns().addAll(name,date,city);
        return turnieje;
    }
    public static TableView<TournamentShortInfo> getTournamentsInPeriod(LocalDate begin, LocalDate end, String town) {
        if(end.isBefore(begin)) {
            throw new IllegalArgumentException("incorrect Dates");
        }
        TableView<TournamentShortInfo> turnieje;

        TableColumn<TournamentShortInfo,String> name = new TableColumn<>("Name");
        name.setMinWidth(200);
        name.setCellValueFactory(new PropertyValueFactory<>("name"));

        TableColumn<TournamentShortInfo,String> date= new TableColumn<>("Date");
        date.setMinWidth(100);
        date.setCellValueFactory(new PropertyValueFactory<>("date"));
        TableColumn<TournamentShortInfo,String> city = new TableColumn<>("City");
        city.setMinWidth(100);
        city.setCellValueFactory(new PropertyValueFactory<>("city"));
        turnieje = new TableView<>();
        turnieje.setItems(QueryResultToListConverter.getTheListOfAllTournamentsInPeriodInCity(begin,end,town));
        turnieje.getColumns().addAll(name,date,city);
        return turnieje;
    }
    public static void getTournamentInfo(int Id) {



    }

}
