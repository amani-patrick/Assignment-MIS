package com.app.submission.onlinesubmissionsystem_.util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;

import com.app.submission.onlinesubmissionsystem_.model.User;
import com.app.submission.onlinesubmissionsystem_.model.Assignment;
import com.app.submission.onlinesubmissionsystem_.model.Submission;
import com.app.submission.onlinesubmissionsystem_.model.PasswordReset;
// Import other entity models as needed

public class HibernateUtil {
    private static SessionFactory sessionFactory;
    
    static {
        try {
            Configuration configuration = new Configuration();
            
            // Configure using hibernate.cfg.xml
            configuration.configure();
            
            // Register all entity classes
            configuration.addAnnotatedClass(User.class);
            configuration.addAnnotatedClass(Assignment.class);
            configuration.addAnnotatedClass(Submission.class);
            configuration.addAnnotatedClass(PasswordReset.class);
            // Add other entity classes as needed
            
            // Set property to update schema
            configuration.setProperty("hibernate.hbm2ddl.auto", "update");
            
            ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                    .applySettings(configuration.getProperties()).build();
            
            sessionFactory = configuration.buildSessionFactory(serviceRegistry);
            System.out.println("Hibernate SessionFactory initialized successfully");
        } catch (Exception e) {
            System.err.println("Error initializing Hibernate SessionFactory: " + e.getMessage());
            e.printStackTrace();
            throw new ExceptionInInitializerError(e);
        }
    }
    
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
    
    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
