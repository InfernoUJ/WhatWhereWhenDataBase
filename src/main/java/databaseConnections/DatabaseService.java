package databaseConnections;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

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
        //returns: name, date, city

        return null;
    }

    public List<Object[]> getTournamentsInPeriod(Date begin,Date finidh) {
        //returns: name, date, city in date

        return null;
    }
    public List<Object[]> getAllTournamentsInRegion(String name) {
        //returns: name, date, city

        return null;
    }
    public List<Object[]> getAllTournamentsInRegionInPeriod(Date begin, Date end, String name) {
        //returns: name, date, city

        return null;
    }
    public List<Object[]> getTeamInTournament(String tournamentName, String name) {
        //returns: the players in the team: Surname, Name, Role

        return null;
    }
    public List<Object[]> getRatingLists() {
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


}


