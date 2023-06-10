package databaseConnections;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.List;

public class DatabaseService {
    private static EntityManager em;

    public DatabaseService() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("WhatWhereWhenPersistence");
        em = emf.createEntityManager();
    }
    //create needed methods here
    public List<Object[]> getAllTournamentsWithDatesAndLocalizationsSortedByDate() {
        return null;
    }
}
