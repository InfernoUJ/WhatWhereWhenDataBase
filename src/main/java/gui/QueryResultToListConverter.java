package gui;

import databaseConnections.DatabaseService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import utilityClasses.TournamentShortInfo;

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
            temp.setDate((Date)row[1]);
            temp.setCity((String)row[2]);
            tournaments.add(temp);
        }


        return tournaments;
    }
    public static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsInPeriod(Date begin, Date end) {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getTournamentsInPeriod(begin,end);
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
    public static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsInCity(String city) {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getAllTournamentsInRegion(city);
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
    public static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsInPeriodInCity(Date begin, Date end, String city) {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getAllTournamentsInRegionInPeriod(begin,end,city);
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
