package gui;

import databaseConnections.DatabaseService;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import utilityClasses.*;

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

    public static TournamentInfo getTournamentInfo(int id) {
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

    public static PersonInfo getPlayerInfo(int id, LocalDate date) {
        List<Object[]> mainInfo = new DatabaseService().getPlayerInfo(id);
        PersonInfo personInfo = new PersonInfo();
        personInfo.setId(id);
        personInfo.setPlayerSurname((String)(mainInfo.get(0)[0]));
        personInfo.setPlayerName((String) (mainInfo.get(0)[1]));
        personInfo.setGender((String) (mainInfo.get(0)[2]));
        personInfo.setBirthday(((Date) mainInfo.get(0)[3]).toLocalDate());
        personInfo.setRating(new DatabaseService().getRatingForPerson(id,date));
        return personInfo;
    }
    public static ObservableList<PersonInfoWithRole> getParticipantsOfTeamInTournament(int id, String name) {
        List<Object[]> people = new DatabaseService().getTeamInTournament(id,name);

        ObservableList<PersonInfoWithRole> result = FXCollections.observableArrayList();
        for(Object[] e: people) {
            PersonInfoWithRole temp = new PersonInfoWithRole();
            temp.setPlayerSurname((String) e[0]);
            temp.setPlayerName((String) e[1]);
            temp.setRola((String) e[2]);
            result.add(temp);
        }

        return result;
    }
    public static ObservableList<TeamResult> getTournamentResults(int id) {
        List<Object[]> mainInfo = new DatabaseService().getTournamentResults(id);
        ObservableList<TeamResult> results = FXCollections.observableArrayList();
        for(Object[] e : mainInfo) {
            TeamResult temp = new TeamResult();
            temp.setId((int)(e[2]));
            temp.setResult((long)e[1]);
            temp.setName((String) e[0]);
            results.add(temp);
        }
        return results;
    }

    public static ObservableList<Question> getQuestionsForTournament(int id) {
        List<Object[]> mainInfo = new DatabaseService().getQuestionsForTournament(id);
        ObservableList<Question>result  = FXCollections.observableArrayList();
        for(Object[] e : mainInfo) {
            Question temp = new Question();
            temp.setId((int)e[4]);
            temp.setNumerPytania((int)e[0]);
            temp.setTresc((String) e[1]);
            temp.setOdpowiedz((String) e[2]);
            temp.setKategoria((String) e[3]);
            result.add(temp);
        }
        return result;
    }
    public static ObservableList<PersonInfo> getRatingList(LocalDate date) {
        List<Object[]> allIds = new DatabaseService().getAllPlayersId();
        ObservableList<PersonInfo> results = FXCollections.observableArrayList();
        for(Object[] e : allIds) {
            PersonInfo temp = getPlayerInfo((int)e[0],date);
            results.add(temp);


        }

        return results;
    }

}
