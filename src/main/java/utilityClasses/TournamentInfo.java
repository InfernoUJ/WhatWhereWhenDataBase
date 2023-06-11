package utilityClasses;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class TournamentInfo {
    private String nazwa;
    private int Id;
    private String opis;
    private LocalDate data_startu;
    private LocalDate data_konca;
    private String miejscowosc;
    private String ulica;
    private String kod_pocztowy;
    private String numer_budynku;
    private String numer_mieszkania;
    private List<Reward> nagrody = new ArrayList<>();
    private String organizator;
    private String sedzia;

    public String getOrganizator() {
        return organizator;
    }

    public void setOrganizator(String organizator) {
        this.organizator = organizator;
    }

    public String getSedzia() {
        return sedzia;
    }

    public void setSedzia(String sedzia) {
        this.sedzia = sedzia;
    }

    public String getNazwa() {
        return nazwa;
    }

    public void setNazwa(String nazwa) {
        this.nazwa = nazwa;
    }

    public int getId() {
        return Id;
    }

    public void setId(int id) {
        Id = id;
    }

    public String getOpis() {
        return opis;
    }

    public void setOpis(String opis) {
        this.opis = opis;
    }

    public LocalDate getData_startu() {
        return data_startu;
    }

    public void setData_startu(LocalDate data_startu) {
        this.data_startu = data_startu;
    }

    public LocalDate getData_konca() {
        return data_konca;
    }

    public void setData_konca(LocalDate data_konca) {
        this.data_konca = data_konca;
    }

    public String getMiejscowosc() {
        return miejscowosc;
    }

    public void setMiejscowosc(String miejscowosc) {
        this.miejscowosc = miejscowosc;
    }

    public String getUlica() {
        return ulica;
    }

    public void setUlica(String ulica) {
        this.ulica = ulica;
    }

    public String getKod_pocztowy() {
        return kod_pocztowy;
    }

    public void setKod_pocztowy(String kod_pocztowy) {
        this.kod_pocztowy = kod_pocztowy;
    }

    public String getNumer_budynku() {
        return numer_budynku;
    }

    public void setNumer_budynku(String numer_budynku) {
        this.numer_budynku = numer_budynku;
    }

    public String getNumer_mieszkania() {
        return numer_mieszkania;
    }

    public void setNumer_mieszkania(String numer_mieszkania) {
        this.numer_mieszkania = numer_mieszkania;
    }

    public List<Reward> getNagrody() {
        return nagrody;
    }

    public void setNagrody(List<Reward> nagrody) {
        this.nagrody = nagrody;
    }
}
