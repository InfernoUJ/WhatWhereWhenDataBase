package home.controllers;

import home.model.TeamModel;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.layout.GridPane;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;

public class TournamentShowController implements Initializable {

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

        place.setCellValueFactory(new PropertyValueFactory<>("Place"));
        teamName.setCellValueFactory(new PropertyValueFactory<>("TeamName"));
        points.setCellValueFactory(new PropertyValueFactory<>("Points"));
        tourney.setItems(teamsModels);
    }

    private ObservableList<TeamModel> teamsModels = FXCollections.observableArrayList(new TeamModel(1, "Amos", 112),
            new TeamModel(2,"Amos", 100),
            new TeamModel(3,"Amos", 88),
            new TeamModel(4,"Amos", 44)
    );

    

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