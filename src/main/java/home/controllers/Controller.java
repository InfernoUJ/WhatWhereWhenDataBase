package home.controllers;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.image.Image;
import javafx.stage.Modality;
import javafx.stage.Stage;
import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

public class Controller implements Initializable {

    @FXML
    private Button btnTournaments;

    @FXML
    private Button btnParticipants;

    @FXML
    private Button btn_Timetable;

    @FXML
    private Button btnSettings;

    @FXML
    private Button btnUpdate;

    @FXML
    private Button btnClasses;

    @FXML
    public void handleButtonClicks(javafx.event.ActionEvent mouseEvent) {
        if (mouseEvent.getSource() == btnTournaments) {
            loadStage("fxml/Tournaments.fxml");
        } else if (mouseEvent.getSource() == btnParticipants) {
            loadStage("fxml/Participants.fxml");
        } else if (mouseEvent.getSource() == btn_Timetable) {
            loadStage("fxml/Timetable.fxml");
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    public static void loadStage(String fxml) {
        try {
            Parent root = FXMLLoader.load(Controller.class.getClassLoader().getResource(fxml));
            Stage stage = new Stage();
            stage.setScene(new Scene(root));
            stage.getIcons().add(new Image("/home/icons/icon.png"));
            stage.initModality(Modality.APPLICATION_MODAL);
            stage.show();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}