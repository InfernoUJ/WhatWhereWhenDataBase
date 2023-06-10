package databaseConnections;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.Properties;

public class QueryExecutor {
    private static EntityManager em;

    public QueryExecutor() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("WhatWhereWhenPersistence");
        em = emf.createEntityManager();
    }
    //create needed methods here

}
