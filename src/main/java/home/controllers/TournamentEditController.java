package home.controllers;

import home.model.TeamModel;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;

public class TournamentEditController implements Initializable {

    @FXML
    private TableView<TeamModel> tourney;
    
    @FXML
    public TableColumn<TeamModel, Integer> place;

    @FXML
    public TableColumn<TeamModel, String> teamName;

    @FXML
    public TableColumn<TeamModel, Integer> points;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    

    @FXML
    public void handleButtonClicks(javafx.event.ActionEvent mouseEvent) {
//        if (mouseEvent.getSource() == btnTournaments) {
//            loadStage("fxml/Tournaments.fxml");
//        } else if (mouseEvent.getSource() == btnParticipants) {
//            loadStage("fxml/Participants.fxml");
//        } else if (mouseEvent.getSource() == btn_Timetable) {
//            loadStage("fxml/Timetable.fxml");
//        }
    }
    


}