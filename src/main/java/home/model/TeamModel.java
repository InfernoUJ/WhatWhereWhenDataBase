package home.model;

import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;

public class TeamModel {

    private SimpleIntegerProperty place;
    private SimpleStringProperty teamName;
    private SimpleIntegerProperty points;

    public TeamModel(int place, String teamName, int points) {
        this.place = new SimpleIntegerProperty(place);
        this.teamName = new SimpleStringProperty(teamName);
        this.points = new SimpleIntegerProperty(points);
    }
    
    

    public int getPlace() {
        return place.get();
    }

    public void setPlace(int place) {
        this.place = new SimpleIntegerProperty(place);
    }

    public String getTeamName() {
        return teamName.get();
    }

    public void setTeamName(String teamName) {
        this.teamName = new SimpleStringProperty(teamName);
    }

    public int getPoints() {
        return points.get();
    }

    public void setPoints(int points) {
        this.points = new SimpleIntegerProperty(points);
    }

    
}
