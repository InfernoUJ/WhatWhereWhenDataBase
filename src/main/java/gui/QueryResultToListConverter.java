package gui;

import databaseConnections.DatabaseService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import utilityClasses.RankingShortInfo;
import utilityClasses.TournamentInfo;
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
            temp.setId((int)row[3]);
            tournaments.add(temp);
        }


        return tournaments;
    }


    public static ObservableList<RankingShortInfo> getAllRankingsInPeriod(LocalDate date) {
        ObservableList<RankingShortInfo> result = FXCollections.observableArrayList();
        for(int i = 0; i < 1000;i++) {
            RankingShortInfo temp = new RankingShortInfo();
            temp.setPlayerSurname("dcba");
            temp.setPlayerName("abcd");
            temp.setRating(28);
            temp.setId(i);
            result.add(temp);
        }
        return result;
    }

    public static TournamentInfo getTournamentResult(int Id) {

        TournamentInfo temp = new TournamentInfo();
        temp.setKomunikatOrganizacyjny("ajisdifj");
        temp.setName("aaaa");
        temp.setId(Id);


        return temp;
    }



}
