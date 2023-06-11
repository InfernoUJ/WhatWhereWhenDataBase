package databaseConnections;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DatabaseService {
    private static EntityManager em;

    public DatabaseService() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("WhatWhereWhenPersistence");
        em = emf.createEntityManager();
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
    public List<Object[]> getRatingLists(LocalDate date) {
        //returns: All  Players:Surname, Name, Rating Sorted By Rating

        return null;
    }
    public long amountOfTournaments() {
        Query q = em.createNativeQuery("SELECT COUNT(*) FROM turnieje");
        return (long)(q.getResultList().get(0));
    }
    public List<Object[]> getTournamentResults(int id) {
        Query q = em.createNativeQuery("SELECT DISTINCT  z.nazwa, compute_team_score(z.nazwa,:id) FROM zespoly AS z JOIN sklady_w_zespolach AS s ON z.id = s.id_zespolu WHERE s.id_turnieju = :id ORDER BY 2 DESC;");
        q.setParameter("id",id);
        return q.getResultList();
    }

    public List<Object[]> getPlayerInfo() {
        //returns: Player:Surname, Name, age, gender,

        return null;
    }
    public List<Object[]> getBadAutors() {
        //returns: Player:Surname, Name and amount of rejected questions

        return null;
    }
    public List<Object[]> displayTournamentInfo(int id) {
        //returns: Name,Start and finish Dates, localization, description, staff

        return null;
    }


}


