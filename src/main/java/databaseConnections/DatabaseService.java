package databaseConnections;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DatabaseService {
    private static EntityManager em;

    public DatabaseService() {
        if(em==null) {
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("WhatWhereWhenPersistence");
            em = emf.createEntityManager();
        }
    }





    //create needed methods here
    public List<Object[]> getAllTournamentsWithDatesAndCitySortedByDate() {
        Query q = em.createNativeQuery("SELECT t.nazwa, t.data_startu,m.nazwa, t.id FROM turnieje AS t JOIN adresy AS a ON t.id =a.id  JOIN miejscowosci AS m ON m.id = a.id ORDER BY 2; ");
        return q.getResultList();
    }

    public List<Object[]> getTournamentsInPeriod(LocalDate begin,LocalDate finish) {
        //returns: name, date, city in date
        Query q = em.createNativeQuery("SELECT t.nazwa, t.data_startu,m.nazwa, t.id FROM turnieje AS t JOIN adresy AS a ON t.id =a.id  JOIN miejscowosci AS m ON m.id = a.id WHERE t.data_startu >= :begin AND t.data_konca <= :finish ORDER BY 2;");
        q.setParameter("begin",begin);
        q.setParameter("finish",finish);
        return q.getResultList();
    }
    public List<Object[]> getAllTournamentsInRegion(String name) {
        //returns: name, date, city
        Query q = em.createNativeQuery("SELECT t.nazwa, t.data_startu,m.nazwa, t.id FROM turnieje AS t JOIN adresy AS a ON t.id =a.id  JOIN miejscowosci AS m ON m.id = a.id WHERE m.nazwa = :nazwa ORDER BY 2;");
        q.setParameter("nazwa",name);
        return q.getResultList();
    }
    public List<Object[]> getAllTournamentsInRegionInPeriod(LocalDate begin, LocalDate finish, String name) {
        //returns: name, date, city
        Query q = em.createNativeQuery("SELECT t.nazwa, t.data_startu,m.nazwa, t.id FROM turnieje AS t JOIN adresy AS a ON t.id =a.id  JOIN miejscowosci AS m ON m.id = a.id WHERE t.data_startu >= :begin AND t.data_konca <= :finish AND m.nazwa = :nazwa ORDER BY 2;");
        q.setParameter("begin",begin);
        q.setParameter("finish",finish);
        q.setParameter("nazwa",name);
        return q.getResultList();
    }
    public List<Object[]> getTeamInTournament(int idTournament, String name) {
        //returns: the players in the team: Surname, Name, Role
        Query q = em.createNativeQuery("SELECT u.nazwisko, u.imie, r.nazwa, z.id FROM uczestnicy AS u JOIN sklady_w_zespolach AS s ON u.id =s.id_osoby  JOIN zespoly AS z ON z.id = s.id_zespolu JOIN role AS r ON r.id = s.rola  WHERE s.id_turnieju = :id AND z.nazwa = :name   ; ");
        q.setParameter("id",idTournament);
        q.setParameter("name",name);
        return q.getResultList();
    }
    public Double getRatingForPerson(int id, LocalDate date) {
        Query q = em.createNativeQuery("SELECT s.id_turnieju, z.nazwa FROM sklady_w_zespolach AS s JOIN zespoly AS z ON z.id = s.id_zespolu JOIN turnieje AS t ON s.id_turnieju = t.id WHERE s.id_osoby = :id AND t.data_konca < :date ;");
        q.setParameter("id",id);
        q.setParameter("date", Date.valueOf(date));
        List<Object[]> turnieje = q.getResultList();
        Double result = Double.valueOf(0);
        for(Object[] e : turnieje) {
            Query temp = em.createNativeQuery("SELECT compute_team_score(:name, :id ),5 ;");
            temp.setParameter("id", (int) e[0]);
            temp.setParameter("name", (String)e[1]);
            List<Object[]> bb = temp.getResultList();
            Double b = ((Integer)bb.get(0)[0]).doubleValue();

            result += b;
        }
        if(turnieje.isEmpty()) {
            return 0.0;
        }
        result = result/turnieje.size();
        return result;
    }
    public long amountOfTournaments() {
        Query q = em.createNativeQuery("SELECT COUNT(*) FROM turnieje");
        return (long)(q.getResultList().get(0));
    }
    public List<Object[]> getTournamentResults(int id) {
        Query q = em.createNativeQuery("SELECT DISTINCT  z.nazwa, compute_team_score(z.nazwa,:id),z.id FROM zespoly AS z JOIN sklady_w_zespolach AS s ON z.id = s.id_zespolu WHERE s.id_turnieju = :id ORDER BY 2 DESC;");
        q.setParameter("id",id);
        return q.getResultList();
    }

    public List<Object[]> getPlayerInfo(int id) {
        //returns: Player:Surname, Name, age, gender,
        Query q = em.createNativeQuery("SELECT nazwisko, imie, plec, data_urodzenia, id FROM uczestnicy WHERE id = :id ;");
        q.setParameter("id",id);

        return q.getResultList();

    }
    public List<Object[]> getBadAutors() {
        //returns: Player:Surname, Name and amount of rejected questions

        return null;
    }
    public List<Object[]> displayTournamentInfo(int id) {
        //returns: Name,Start and finish Dates, localization, description, staff
        Query q = em.createNativeQuery("SELECT t.nazwa, t.opis, t.data_startu, t.data_konca, m.nazwa, a.ulica, a.kod_pocztowy, a.numer_budynku, coalesce(a.numer_mieszkania,'0'), t.id FROM turnieje AS t JOIN adresy AS a ON t.id_adresu = a.id JOIN miejscowosci AS m ON m.id = a.miejscowosc WHERE t.id = :id ;");
        q.setParameter("id",id);
        return q.getResultList();
    }

    public List<Object[]> getRewardsForTournament(int id) {
        Query q = em.createNativeQuery("SELECT nt.miejsce, n.opis FROM nagrody_w_turniejach AS nt JOIN nagrody AS n ON n.id = nt.id_nagrody WHERE nt.id_turnieju = :id ;");
        q.setParameter("id",id);
        return q.getResultList();
    }
    public List<Object[]> getStaffForTournament(int id) {
        Query q = em.createNativeQuery("SELECT p.nazwisko, p.imie, o.organizator FROM organizacja AS o JOIN uczestnicy AS p ON p.id = o.sedzia_glowny WHERE o.id_turnieju = :id ;");
        q.setParameter("id",id);
        return q.getResultList();
    }

    public List<Object[]> getQuestionsForTournament(int id) {
        Query q = em.createNativeQuery("SELECT pt.numer_pytania, p.tresc, p.odpowiedz, k.nazwa, p.id FROM pytania_na_turniejach AS pt JOIN pytania AS p ON pt.id_pytania = p.id JOIN kategorie AS k ON p.id_kategorii = k.id WHERE pt.id_turnieju = :id ;");
        q.setParameter("id",id);
        return q.getResultList();
    }
    public List<Object[]> getAllPlayersId() {
        Query q = em.createNativeQuery("SELECT id, nazwisko FROM uczestnicy;");
        return q.getResultList();
    }

}


