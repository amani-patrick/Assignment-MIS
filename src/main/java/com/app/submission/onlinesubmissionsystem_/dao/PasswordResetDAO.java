package com.app.submission.onlinesubmissionsystem_.dao;

import com.app.submission.onlinesubmissionsystem_.model.PasswordReset;
import com.app.submission.onlinesubmissionsystem_.util.HibernateUtil;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class PasswordResetDAO {
    
    public void savePasswordReset(PasswordReset passwordReset) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(passwordReset);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    
    public PasswordReset getPasswordResetByToken(String token) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PasswordReset> query = session.createQuery(
                "FROM PasswordReset WHERE token = :token", PasswordReset.class);
            query.setParameter("token", token);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public void deletePasswordReset(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            PasswordReset passwordReset = session.get(PasswordReset.class, id);
            if (passwordReset != null) {
                session.remove(passwordReset);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
} 