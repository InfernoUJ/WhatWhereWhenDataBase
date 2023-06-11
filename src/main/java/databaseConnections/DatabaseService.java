package databaseConnections;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

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
        //returns: name, date, city
        List<Object[]> temp = new ArrayList<>();
        for(int i = 0; i < 1000;i++) {
            Object[] adding = new Object[4];
            adding[0] = new String("turniej123");
            adding[1] = LocalDate.now();
            adding[2] = new String("krakow");
            adding[3] = i;
            temp.add(adding);
        }
        return temp;
    }

    public List<Object[]> getTournamentsInPeriod(LocalDate begin,LocalDate finidh) {
        //returns: name, date, city in date

        return null;
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


