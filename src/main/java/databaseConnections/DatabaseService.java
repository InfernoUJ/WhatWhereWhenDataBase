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
        Query q = em.createNativeQuery("SELECT t.nazwa, t.data_startu,m.nazwa FROM turnieje AS t JOIN adresy AS a ON t.id =a.id  JOIN miejscowosci AS m ON m.id = a.id ORDER BY 2; ");
        return q.getResultList();
    }

    public List<Object[]> getTournamentsInPeriod(LocalDate begin,LocalDate finish) {
        //returns: name, date, city in date
        Query q = em.createNativeQuery("SELECT t.nazwa, t.data_startu,m.nazwa FROM turnieje AS t JOIN adresy AS a ON t.id =a.id  JOIN miejscowosci AS m ON m.id = a.id WHERE t.data_startu >= :begin AND t.data_konca <= :finish ORDER BY 2;");
        q.setParameter("begin",begin);
        q.setParameter("finish",finish);
        return q.getResultList();
    }
    public List<Object[]> getAllTournamentsInRegion(String name) {
        //returns: name, date, city

        return null;
    }
    public List<Object[]> getAllTournamentsInRegionInPeriod(LocalDate begin, LocalDate end, String name) {
        //returns: name, date, city

        return null;
    }
    public List<Object[]> getTeamInTournament(String tournamentName, String name) {
        //returns: the players in the team: Surname, Name, Role

        return null;
    }
    public List<Object[]> getRatingLists(LocalDate date) {
        //returns: All  Players:Surname, Name, Rating Sorted By Rating

        return null;
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


