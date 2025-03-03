package com.app.submission.onlinesubmissionsystem_.controller;

import com.app.submission.onlinesubmissionsystem_.dao.AssignmentDAO;
import com.app.submission.onlinesubmissionsystem_.model.Assignment;
import com.app.submission.onlinesubmissionsystem_.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.File;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/createAssignment")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 10 * 1024 * 1024,  // 10 MB
    maxRequestSize = 15 * 1024 * 1024 // 15 MB
)
public class AssignmentServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "assignment_files";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.INSTRUCTOR) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Create upload directory if it doesn't exist
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Get form parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String deadlineStr = request.getParameter("deadline");
        String classId = request.getParameter("classId");
        
        // Get advanced option parameters
        String maxScoreStr = request.getParameter("maxScore");
        String resources = request.getParameter("resources");
        
        // Handle file upload
        String filePath = null;
        Part filePart = request.getPart("assignmentFile");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            // Generate unique filename to prevent conflicts
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
        }

        // Create and save assignment
        Assignment assignment = new Assignment();
        assignment.setTitle(title);
        assignment.setDescription(description);
        
        // Parse the datetime properly and extract the date portion
        if (deadlineStr != null && !deadlineStr.isEmpty()) {
            try {
                // Parse the datetime string using a formatter that handles the time component
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                LocalDateTime dateTime = LocalDateTime.parse(deadlineStr, formatter);
                
                // Extract just the date portion for the Assignment object
                LocalDate deadlineDate = dateTime.toLocalDate();
                assignment.setDeadline(deadlineDate);
            } catch (Exception e) {
                // Fallback in case of parsing error
                session.setAttribute("notification", "Invalid date format. Please try again.");
                session.setAttribute("notificationType", "error");
                response.sendRedirect("createAssignment.jsp");
                return;
            }
        }
        
        assignment.setInstructor(user);
        assignment.setCreatedBy(user);
        assignment.setFilePath(filePath);
        
        // Set class ID if provided
        if (classId != null && !classId.isEmpty()) {
            assignment.setClassId(Integer.parseInt(classId));
        }
        
        // Set advanced options if provided
        if (maxScoreStr != null && !maxScoreStr.isEmpty()) {
            try {
                int maxScore = Integer.parseInt(maxScoreStr);
                assignment.setMaxScore(maxScore);
            } catch (NumberFormatException e) {
                // Handle invalid input for maxScore
                // If invalid, don't set a max score (it will remain the default 0)
            }
        }
        
        if (resources != null && !resources.isEmpty()) {
            assignment.setResources(resources);
        }

        // Use Hibernate through your DAO to save the assignment
        AssignmentDAO assignmentDAO = new AssignmentDAO();
        assignmentDAO.saveAssignment(assignment);

        // Set success notification
        session.setAttribute("notification", "Assignment created successfully!");
        session.setAttribute("notificationType", "success");

        response.sendRedirect("instructorDashboard.jsp");
    }
}
