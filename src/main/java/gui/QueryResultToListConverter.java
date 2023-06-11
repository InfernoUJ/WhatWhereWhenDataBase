package gui;

import databaseConnections.DatabaseService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import utilityClasses.PersonInfo;
import utilityClasses.Reward;
import utilityClasses.TournamentInfo;
import utilityClasses.TournamentShortInfo;

import java.time.LocalDate;
import java.time.ZoneId;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class QueryResultToListConverter {
    public static ObservableList<TournamentShortInfo> getTheListOfAllTournamentsSortedByDate() {
        DatabaseService generator = new DatabaseService();
        List<Object[]> shortInfo = generator.getAllTournamentsWithDatesAndCitySortedByDate();
        ObservableList<TournamentShortInfo> tournaments = FXCollections.observableArrayList();
        for(Object[] row : shortInfo) {
            TournamentShortInfo temp = new TournamentShortInfo();
            temp.setName((String)row[0]);
            temp.setDate(((Date)row[1]).toLocalDate());
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
            temp.setDate(((Date)row[1]).toLocalDate());
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
            temp.setDate(((Date)row[1]).toLocalDate());
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
            temp.setDate(((Date)row[1]).toLocalDate());
            temp.setCity((String)row[2]);
            temp.setId((int)row[3]);
            tournaments.add(temp);
        }


        return tournaments;
    }


    public static ObservableList<PersonInfo> getAllRankingsInPeriod(LocalDate date) {
        ObservableList<PersonInfo> result = FXCollections.observableArrayList();
        for(int i = 0; i < 1000;i++) {
            PersonInfo temp = new PersonInfo();
            temp.setPlayerSurname("dcba");
            temp.setPlayerName("abcd");
            temp.setRating(28);
            temp.setId(i);
            result.add(temp);
        }
        return result;
    }

    public static TournamentInfo getTournamentResult(int id) {
        List<Object[]> mainInfo = new DatabaseService().displayTournamentInfo(id);
        List<Object[]> rewards = new DatabaseService().getRewardsForTournament(id);
        List<Object[]> personel = new DatabaseService().getStaffForTournament(id);
        TournamentInfo  result = new TournamentInfo();
        result.setId(id);
        List<Reward> nagrody = new ArrayList<>();
        for(int i = 0; i < rewards.size();i++) {
            Reward p = new Reward();
            p.setMiejsce((int)(rewards.get(i)[0]));
            p.setOpis((String) rewards.get(i)[1]);
            nagrody.add(p);
        }
        result.setNagrody(nagrody);
        result.setNazwa((String) mainInfo.get(0)[0]);
        result.setOrganizator((String) personel.get(0)[2]);
        result.setSedzia((String) personel.get(0)[0] + " " + (String) personel.get(0)[1]);
        result.setOpis((String) mainInfo.get(0)[1]);
        result.setData_startu(((Date)mainInfo.get(0)[2]).toLocalDate());
        result.setData_konca(((Date)mainInfo.get(0)[3]).toLocalDate());
        result.setMiejscowosc((String) mainInfo.get(0)[4]);
        result.setUlica((String) mainInfo.get(0)[5]);
        result.setKod_pocztowy((String) mainInfo.get(0)[6]);
        result.setNumer_budynku((String) mainInfo.get(0)[7]);
        result.setNumer_mieszkania((String) mainInfo.get(0)[8]);
        return result;
    }

    public static ObservableList<PersonInfo> getParticipantsOfTeamInTournament(int id, String name) {
        return null;
    }

}
