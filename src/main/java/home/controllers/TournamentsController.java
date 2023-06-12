package home.controllers;

import static home.controllers.Controller.loadStage;
import home.model.ParticipantModel;
import home.model.TournamentModel;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import utilityClasses.Converter;

public class TournamentsController implements Initializable {

    @FXML
    private TableView<TournamentModel> tbData;
    @FXML
    public TableColumn<TournamentModel, String> name;

    @FXML
    public TableColumn<TournamentModel, String> date;

    @FXML
    public TableColumn<TournamentModel, String> city;
    
    @FXML
    public Button btnAdd;
    
    @FXML
    public Button btnEdit;

    @FXML
    public Button btnShow;

    @FXML
    private Label stCount;
        @FXML
    public void handleButtonClicks(javafx.event.ActionEvent mouseEvent) {
        if (mouseEvent.getSource() == btnAdd) {
            loadStage("fxml/TournamentEdit.fxml");
        } else if (mouseEvent.getSource() == btnEdit) {
            loadStage("fxml/TournamentEdit.fxml");
        } else if (mouseEvent.getSource() == btnShow) {
            loadStage("fxml/TournamentShow.fxml");
        }
    }
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {

        loadTournaments();
        stCount.setText("333");
    }


    private ObservableList<TournamentModel> tournamentModels = Converter.getAllTournamentsShortInfo();

    private void loadTournaments()
    {
        name.setCellValueFactory(new PropertyValueFactory<>("name"));
        date.setCellValueFactory(new PropertyValueFactory<>("date"));
        city.setCellValueFactory(new PropertyValueFactory<>("city"));
        tbData.setItems(tournamentModels);
    }

}