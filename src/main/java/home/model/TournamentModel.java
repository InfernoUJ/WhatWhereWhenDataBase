package home.model;

import javafx.beans.property.SimpleStringProperty;
import utilityClasses.TournamentShortInfo;

import java.time.format.DateTimeFormatter;

public class TournamentModel {
    private SimpleStringProperty name;
    private SimpleStringProperty date;
    private SimpleStringProperty city;

    public TournamentModel(TournamentShortInfo input) {
        this.name = new SimpleStringProperty(input.getName());
        DateTimeFormatter temp = DateTimeFormatter.ofPattern("YYYY-MM-DD");
        this.date = new SimpleStringProperty(input.getDate().format(temp));
        this.city = new SimpleStringProperty(input.getCity());
    }

    public String getName() {
        return name.get();
    }

    public SimpleStringProperty nameProperty() {
        return name;
    }

    public void setName(String name) {
        this.name.set(name);
    }

    public String getDate() {
        return date.get();
    }

    public SimpleStringProperty dateProperty() {
        return date;
    }

    public void setDate(String date) {
        this.date.set(date);
    }

    public String getCity() {
        return city.get();
    }

    public SimpleStringProperty cityProperty() {
        return city;
    }

    public void setCity(String city) {
        this.city.set(city);
    }
}
