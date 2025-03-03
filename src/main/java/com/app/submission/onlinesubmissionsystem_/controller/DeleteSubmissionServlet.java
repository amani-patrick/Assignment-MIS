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
import java.io.File;
import java.io.IOException;

@WebServlet("/DeleteSubmissionServlet")
public class DeleteSubmissionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.STUDENT) {
            response.sendRedirect("login.jsp");
            return;
        }

        Long submissionId = Long.parseLong(request.getParameter("submissionId"));
        SubmissionDAO submissionDAO = new SubmissionDAO();
        Submission submission = submissionDAO.getSubmissionById(submissionId);

        if (submission != null && submission.getStudent().getId().equals(user.getId())) {
            // Get assignment title for notification message
            String assignmentTitle = submission.getAssignment().getTitle();
            
            // Delete file if it exists
            File file = new File(getServletContext().getRealPath("") + File.separator + submission.getFilePath());
            if (file.exists()) file.delete();
            
            // Delete submission from database
            submissionDAO.deleteSubmission(submissionId);
            
            // Set success notification in session
            session.setAttribute("notification", "Your submission for '" + assignmentTitle + "' has been successfully deleted.");
            session.setAttribute("notificationType", "success");
        } else {
            // Set error notification if submission doesn't exist or doesn't belong to user
            session.setAttribute("notification", "Unable to delete submission. It may have been already deleted or you don't have permission.");
            session.setAttribute("notificationType", "error");
        }

        response.sendRedirect("studentDashboard.jsp");
    }
}
