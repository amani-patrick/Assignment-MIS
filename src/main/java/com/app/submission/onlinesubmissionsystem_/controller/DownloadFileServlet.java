package com.app.submission.onlinesubmissionsystem_.controller;

import com.app.submission.onlinesubmissionsystem_.dao.AssignmentDAO;
import com.app.submission.onlinesubmissionsystem_.dao.SubmissionDAO;
import com.app.submission.onlinesubmissionsystem_.model.Assignment;
import com.app.submission.onlinesubmissionsystem_.model.Submission;
import com.app.submission.onlinesubmissionsystem_.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Paths;

@WebServlet("/DownloadFileServlet")
public class DownloadFileServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String type = request.getParameter("type");
        String idStr = request.getParameter("id");
        
        if (type == null || idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }
        
        Long id;
        try {
            id = Long.parseLong(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
            return;
        }
        
        String filePath = null;
        String fileName = null;
        
        if ("assignment".equals(type)) {
            AssignmentDAO assignmentDAO = new AssignmentDAO();
            Assignment assignment = assignmentDAO.getAssignmentById(id);
            
            if (assignment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Assignment not found");
                return;
            }
            
            filePath = assignment.getFilePath();
            fileName = "assignment_" + assignment.getId() + "_" + assignment.getTitle().replaceAll("\\s+", "_") + getFileExtension(filePath);
            
        } else if ("submission".equals(type)) {
            SubmissionDAO submissionDAO = new SubmissionDAO();
            Submission submission = submissionDAO.getSubmissionById(id);
            
            if (submission == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Submission not found");
                return;
            }
            
            // Check permissions - students should only access their own submissions
            if (user.getRole() == com.app.submission.onlinesubmissionsystem_.model.Role.STUDENT && 
                !submission.getStudent().getId().equals(user.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
            filePath = submission.getFilePath();
            fileName = "submission_" + submission.getId() + getFileExtension(filePath);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file type");
            return;
        }
        
        if (filePath == null || filePath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }
        
        File file = new File(filePath);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on server");
            return;
        }
        
        // Set content type based on file extension
        String contentType = getServletContext().getMimeType(filePath);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        // Setup HTTP headers for download
        response.setContentType(contentType);
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        // Stream file to response
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
    
    private String getFileExtension(String filePath) {
        if (filePath == null) return "";
        String fileName = Paths.get(filePath).getFileName().toString();
        int lastDotIndex = fileName.lastIndexOf('.');
        return (lastDotIndex > 0) ? fileName.substring(lastDotIndex) : "";
    }
} 