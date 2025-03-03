package com.app.submission.onlinesubmissionsystem_.controller;

import com.app.submission.onlinesubmissionsystem_.dao.UserDAO;
import com.app.submission.onlinesubmissionsystem_.dao.PasswordResetDAO;
import com.app.submission.onlinesubmissionsystem_.model.User;
import com.app.submission.onlinesubmissionsystem_.model.PasswordReset;
import com.app.submission.onlinesubmissionsystem_.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;
import java.time.LocalDateTime;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);
        
        if (user != null) {
            // Generate a unique token
            String token = UUID.randomUUID().toString();
            
            // Set expiration time (24 hours from now)
            LocalDateTime expiryTime = LocalDateTime.now().plusHours(24);
            
            // Create a password reset record
            PasswordReset passwordReset = new PasswordReset();
            passwordReset.setUserId(user.getId());
            passwordReset.setToken(token);
            passwordReset.setExpiryTime(expiryTime);
            
            // Save the password reset record
            PasswordResetDAO passwordResetDAO = new PasswordResetDAO();
            passwordResetDAO.savePasswordReset(passwordReset);
            
            // Send the password reset email
            String resetLink = request.getScheme() + "://" + request.getServerName() + 
                              ":" + request.getServerPort() + 
                              request.getContextPath() + 
                              "/resetPassword?token=" + token;
            
            String subject = "Password Reset Request";
            String body = "Dear " + user.getName() + ",\n\n" +
                         "You have requested to reset your password. Please click the link below to reset your password:\n\n" +
                         resetLink + "\n\n" +
                         "This link will expire in 24 hours.\n\n" +
                         "If you did not request a password reset, please ignore this email.\n\n" +
                         "Regards,\nOnline Submission System";
            
            EmailService.sendEmail(email, subject, body);
            
            request.setAttribute("message", "A password reset link has been sent to your email address.");
        } else {
            request.setAttribute("error", "Email address not found!");
        }
        
        request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
    }
} 