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
}
