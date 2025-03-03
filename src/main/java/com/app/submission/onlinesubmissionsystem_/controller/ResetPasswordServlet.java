package com.app.submission.onlinesubmissionsystem_.controller;

import com.app.submission.onlinesubmissionsystem_.dao.UserDAO;
import com.app.submission.onlinesubmissionsystem_.dao.PasswordResetDAO;
import com.app.submission.onlinesubmissionsystem_.model.User;
import com.app.submission.onlinesubmissionsystem_.model.PasswordReset;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        
        if (token == null || token.isEmpty()) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        PasswordResetDAO passwordResetDAO = new PasswordResetDAO();
        PasswordReset passwordReset = passwordResetDAO.getPasswordResetByToken(token);
        
        if (passwordReset == null || passwordReset.getExpiryTime().isBefore(LocalDateTime.now())) {
            request.setAttribute("error", "Invalid or expired password reset link!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("token", token);
        request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.setAttribute("token", token);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }
        
        PasswordResetDAO passwordResetDAO = new PasswordResetDAO();
        PasswordReset passwordReset = passwordResetDAO.getPasswordResetByToken(token);
        
        if (passwordReset == null || passwordReset.getExpiryTime().isBefore(LocalDateTime.now())) {
            request.setAttribute("error", "Invalid or expired password reset link!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Hash the new password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        
        // Update the user's password
        UserDAO userDAO = new UserDAO();
        userDAO.updatePassword(passwordReset.getUserId(), hashedPassword);
        
        // Delete the password reset token
        passwordResetDAO.deletePasswordReset(passwordReset.getId());
        
        request.setAttribute("message", "Your password has been reset successfully. You can now login with your new password.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
} 