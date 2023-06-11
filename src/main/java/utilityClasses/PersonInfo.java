package utilityClasses;

import java.time.LocalDate;

public class PersonInfo {
    private String playerSurname;
    private String playerName;
    LocalDate birthday;
    public String getPlayerSurname() {
        return playerSurname;
    }

    public void setPlayerSurname(String playerSurname) {
        this.playerSurname = playerSurname;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    private int rating;
    private int id;

    public LocalDate getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
    }
}
