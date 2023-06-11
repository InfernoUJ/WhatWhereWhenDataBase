package utilityClasses;

import java.time.LocalDate;

public class TournamentInfo {
    private String name;
    private int Id;

    public int getId() {
        return Id;
    }

    public void setId(int id) {
        Id = id;
    }

    private String komunikatOrganizacyjny;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getKomunikatOrganizacyjny() {
        return komunikatOrganizacyjny;
    }

    public void setKomunikatOrganizacyjny(String komunikatOrganizacyjny) {
        this.komunikatOrganizacyjny = komunikatOrganizacyjny;
    }
}
