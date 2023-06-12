package home.controllers;

import home.model.ParticipantModel;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import utilityClasses.Converter;

import java.net.URL;
import java.util.ResourceBundle;

public class ParticipantsController implements Initializable {

    @FXML
    private TableView<ParticipantModel> tbData;
    @FXML
    public TableColumn<ParticipantModel, String> nazwisko;

    @FXML
    public TableColumn<ParticipantModel, String> imie;

    @FXML
    public TableColumn<ParticipantModel, Double> ranking;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

        nazwisko.setCellValueFactory(new PropertyValueFactory<>("nazwisko"));
        imie.setCellValueFactory(new PropertyValueFactory<>("imie"));
        ranking.setCellValueFactory(new PropertyValueFactory<>("ranking"));
        tbData.setItems(participantsModels);
    }

    private ObservableList<ParticipantModel> participantsModels = Converter.getRanking();


}