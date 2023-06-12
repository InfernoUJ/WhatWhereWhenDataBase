package home.model;


import javafx.beans.property.SimpleDoubleProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import utilityClasses.PersonInfo;
import utilityClasses.TournamentInfo;

public class ParticipantModel {

    private SimpleStringProperty nazwisko;
    private SimpleStringProperty imie;
    private SimpleDoubleProperty ranking;

    public ParticipantModel(PersonInfo personInfo) {
        this.nazwisko = new SimpleStringProperty(personInfo.getPlayerSurname());
        this.imie = new SimpleStringProperty(personInfo.getPlayerName());
        this.ranking = new SimpleDoubleProperty(personInfo.getRating());
    }

    public String getNazwisko() {
        return nazwisko.get();
    }

    public SimpleStringProperty nazwiskoProperty() {
        return nazwisko;
    }

    public void setNazwisko(String nazwisko) {
        this.nazwisko.set(nazwisko);
    }

    public String getImie() {
        return imie.get();
    }

    public SimpleStringProperty imieProperty() {
        return imie;
    }

    public void setImie(String imie) {
        this.imie.set(imie);
    }

    public double getRanking() {
        return ranking.get();
    }

    public SimpleDoubleProperty rankingProperty() {
        return ranking;
    }

    public void setRanking(double ranking) {
        this.ranking.set(ranking);
    }
}