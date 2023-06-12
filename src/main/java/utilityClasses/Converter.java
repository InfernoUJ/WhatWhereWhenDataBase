package utilityClasses;

import gui.QueryResultToListConverter;
import home.model.ParticipantModel;
import home.model.TournamentModel;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import java.time.LocalDate;

public class Converter {

    public static ObservableList<TournamentModel> getAllTournamentsShortInfo() {
        ObservableList<TournamentShortInfo> input = QueryResultToListConverter.getTheListOfAllTournamentsSortedByDate();
        ObservableList<TournamentModel> result = FXCollections.observableArrayList();
        for(TournamentShortInfo e : input) {
            result.add(new TournamentModel(e));
        }
        return result;
    }

    public static ObservableList<ParticipantModel> getRanking() {
        ObservableList<PersonInfo> input = QueryResultToListConverter.getRatingList(LocalDate.now());
        ObservableList<ParticipantModel> result = FXCollections.observableArrayList();
        for(PersonInfo e : input) {
            result.add(new ParticipantModel(e));
        }
        return result;
    }
}
