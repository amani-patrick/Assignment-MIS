package com.app.submission.onlinesubmissionsystem_.controller;

import com.app.submission.onlinesubmissionsystem_.dao.SubmissionDAO;
import com.app.submission.onlinesubmissionsystem_.model.Submission;
import com.app.submission.onlinesubmissionsystem_.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/GradeSubmissionServlet")
public class GradeSubmissionServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is an instructor
        if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.INSTRUCTOR) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get parameters
            String submissionIdStr = request.getParameter("submissionId");
            String assignmentIdStr = request.getParameter("assignmentId");
            String scoreStr = request.getParameter("score");
            String feedback = request.getParameter("feedback");
            
            if (submissionIdStr == null || scoreStr == null) {
                throw new IllegalArgumentException("Missing required parameters");
            }
            
            long submissionId = Long.parseLong(submissionIdStr);
            long assignmentId = Long.parseLong(assignmentIdStr);
            double score = Double.parseDouble(scoreStr);
            
            // Update the submission with the grade and feedback
            SubmissionDAO submissionDAO = new SubmissionDAO();
            Submission submission = submissionDAO.getSubmissionById(submissionId);
            
            if (submission == null) {
                throw new IllegalArgumentException("Submission not found");
            }
            
            // Set the score and feedback
            submission.setScore(score);
            submission.setFeedback(feedback);
            
            // Update the submission in the database
            submissionDAO.updateSubmission(submission);
            
            // Set success notification
            session.setAttribute("notification", "Submission graded successfully!");
            session.setAttribute("notificationType", "success");
            
        } catch (NumberFormatException e) {
            session.setAttribute("notification", "Invalid input format. Please enter a valid number for the score.");
            session.setAttribute("notificationType", "error");
        } catch (Exception e) {
            session.setAttribute("notification", "Error grading submission: " + e.getMessage());
            session.setAttribute("notificationType", "error");
        }
        
        // Redirect back to the view submissions page
        String assignmentId = request.getParameter("assignmentId");
        response.sendRedirect("viewSubmissions.jsp?assignmentId=" + assignmentId);
    }
} 