package gui;

import databaseConnections.DatabaseService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import utilityClasses.TournamentShortInfo;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

public class QueryResultToListConverter {
    public static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsSortedByDate() {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getAllTournamentsWithDatesAndCitySortedByDate();
        ObservableList<TournamentShortInfo> tournaments = FXCollections.observableArrayList();
        for(Object[] row : shortInfo) {
            TournamentShortInfo temp = new TournamentShortInfo();
            temp.setName((String)row[0]);
            temp.setDate((LocalDate)row[1]);
            temp.setCity((String)row[2]);
            tournaments.add(temp);
        }


        return tournaments;
    }
    public static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsInPeriod(LocalDate begin, LocalDate end) {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getTournamentsInPeriod(begin,end);
        ObservableList<TournamentShortInfo> tournaments = FXCollections.observableArrayList();
        for(Object[] row : shortInfo) {
            TournamentShortInfo temp = new TournamentShortInfo();
            temp.setName((String)row[0]);
            temp.setDate((LocalDate)row[1]);
            temp.setCity((String)row[2]);
            tournaments.add(temp);
        }


        return tournaments;
    }
    public static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsInCity(String city) {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getAllTournamentsInRegion(city);
        ObservableList<TournamentShortInfo> tournaments = FXCollections.observableArrayList();
        for(Object[] row : shortInfo) {
            TournamentShortInfo temp = new TournamentShortInfo();
            temp.setName((String)row[0]);
            temp.setDate((LocalDate)row[1]);
            temp.setCity((String)row[2]);
            tournaments.add(temp);
        }


        return tournaments;
    }
    public static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsInPeriodInCity(LocalDate begin, LocalDate end, String city) {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getAllTournamentsInRegionInPeriod(begin,end,city);
        ObservableList<TournamentShortInfo> tournaments = FXCollections.observableArrayList();
        for(Object[] row : shortInfo) {
            TournamentShortInfo temp = new TournamentShortInfo();
            temp.setName((String)row[0]);
            temp.setDate((LocalDate)row[1]);
            temp.setCity((String)row[2]);
            tournaments.add(temp);
        }


        return tournaments;
    }

}
