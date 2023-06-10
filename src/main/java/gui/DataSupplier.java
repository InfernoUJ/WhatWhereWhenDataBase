package gui;

import databaseConnections.DatabaseService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import utilityClasses.TournamentShortInfo;

import java.util.Date;
import java.util.List;

public class DataSupplier {
    public static TableView<TournamentShortInfo> getAllTournaments() {
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
        turnieje.setItems(getTheListOfAllTournamentsSortedByDate());
        turnieje.getColumns().addAll(name,date,city);
        return turnieje;
    }
    private static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsSortedByDate() {
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
