package utilityClasses;

public class Question {
    private int id;
    private int numerPytania;
    private String tresc;
    private String odpowiedz;
    private String kategoria;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNumerPytania() {
        return numerPytania;
    }

    public void setNumerPytania(int numerPytania) {
        this.numerPytania = numerPytania;
    }

    public String getTresc() {
        return tresc;
    }

    public void setTresc(String tresc) {
        this.tresc = tresc;
    }

    public String getOdpowiedz() {
        return odpowiedz;
    }

    public void setOdpowiedz(String odpowiedz) {
        this.odpowiedz = odpowiedz;
    }

    public String getKategoria() {
        return kategoria;
    }

    public void setKategoria(String kategoria) {
        this.kategoria = kategoria;
    }
}
