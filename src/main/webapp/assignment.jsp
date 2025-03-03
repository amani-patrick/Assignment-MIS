<%--
  Created by IntelliJ IDEA.
  User: Christian
  Date: 2/11/2025
  Time: 1:51 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.submission.onlinesubmissionsystem_.model.Assignment, com.app.submission.onlinesubmissionsystem_.model.User, com.app.submission.onlinesubmissionsystem_.dao.AssignmentDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get assignment ID from request parameter
    String assignmentId = request.getParameter("id");
    Assignment assignment = null;
    
    if (assignmentId != null && !assignmentId.isEmpty()) {
        AssignmentDAO assignmentDAO = new AssignmentDAO();
        assignment = assignmentDAO.getAssignmentById(Long.parseLong(assignmentId));
    }
    
    if (assignment == null) {
        response.sendRedirect(user.getRole() == com.app.submission.onlinesubmissionsystem_.model.Role.STUDENT ? 
                             "studentDashboard.jsp" : "instructorDashboard.jsp");
        return;
    }
    
    boolean isStudent = user.getRole() == com.app.submission.onlinesubmissionsystem_.model.Role.STUDENT;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignment Details | EduSubmit</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6200EA;
            --secondary: #FF4081;
            --accent: #00E5FF;
            --dark: #1A1A2E;
            --light: #FFFFFF;
            --gray: #F0F0F0;
            --success: #4CAF50;
            --danger: #F44336;
            --warning: #FFC107;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--dark);
            color: var(--light);
            overflow-x: hidden;
            background: linear-gradient(to right, #16222A, #3A6073);
            min-height: 100vh;
        }
        
        .assignment-container {
            padding: 2rem 0;
            animation: fadeIn 0.8s ease forwards;
        }
        
        .navbar {
            background: rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            padding: 1rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 20px 20px;
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--light);
        }
        
        .navbar-brand span {
            color: var(--secondary);
        }
        
        .card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            padding: 2rem;
            color: var(--light);
            margin-bottom: 2rem;
            transition: all 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }
        
        .assignment-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            background: linear-gradient(90deg, #FFFFFF, #00E5FF);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .meta-info {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .meta-icon {
            font-size: 1.2rem;
            color: var(--accent);
        }
        
        .meta-label {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.7);
        }
        
        .meta-value {
            font-weight: 500;
        }
        
        .deadline-approaching {
            color: var(--warning);
        }
        
        .deadline-passed {
            color: var(--danger);
        }
        
        .description-title {
            font-weight: 600;
            margin-bottom: 1rem;
            position: relative;
            display: inline-block;
            padding-bottom: 0.5rem;
        }
        
        .description-title::after {
            content: '';
            position: absolute;
            width: 40px;
            height: 3px;
            background: var(--secondary);
            bottom: 0;
            left: 0;
        }
        
        .description-content {
            line-height: 1.7;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 2rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, var(--secondary), #FF7E97);
            color: white;
            box-shadow: 0 8px 20px rgba(255, 64, 129, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(255, 64, 129, 0.4);
            background: linear-gradient(45deg, #FF7E97, var(--secondary));
            color: white;
        }
        
        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: var(--light);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-3px);
            color: var(--light);
        }
        
        .btn-warning {
            background: linear-gradient(45deg, var(--warning), #FFD54F);
            color: #5D4037;
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
        }
        
        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 193, 7, 0.4);
            background: linear-gradient(45deg, #FFD54F, var(--warning));
            color: #5D4037;
        }
        
        .btn-danger {
            background: linear-gradient(45deg, var(--danger), #E57373);
            color: white;
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.3);
        }
        
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(244, 67, 54, 0.4);
            background: linear-gradient(45deg, #E57373, var(--danger));
            color: white;
        }
        
        .resources-section {
            margin-top: 2rem;
        }
        
        .resource-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            background: rgba(255, 255, 255, 0.05);
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .resource-item:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateX(5px);
        }
        
        .resource-icon {
            font-size: 1.5rem;
            color: var(--accent);
        }
        
        .resource-info {
            flex: 1;
        }
        
        .resource-title {
            font-weight: 500;
            margin-bottom: 0.25rem;
        }
        
        .resource-meta {
            font-size: 0.8rem;
            color: rgba(255, 255, 255, 0.7);
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="#">Edu<span>Submit</span> | Assignment Details</a>
            <div>
                <a href="<%= isStudent ? "studentDashboard.jsp" : "instructorDashboard.jsp" %>" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>
        </div>
    </nav>

    <div class="container assignment-container">
        <div class="card">
            <h1 class="assignment-title"><%= assignment.getTitle() %></h1>
            
            <div class="meta-info">
                <div class="meta-item">
                    <i class="far fa-calendar-alt meta-icon"></i>
                    <div>
                        <div class="meta-label">Deadline</div>
                        <div class="meta-value"><%= assignment.getDeadline() %></div>
                    </div>
                </div>
                
                <div class="meta-item">
                    <i class="fas fa-user-tie meta-icon"></i>
                    <div>
                        <div class="meta-label">Instructor</div>
                        <div class="meta-value"><%= assignment.getInstructor().getName() %></div>
                    </div>
                </div>
                
                <% if (assignment.getMaxScore() > 0) { %>
                <div class="meta-item">
                    <i class="fas fa-star meta-icon"></i>
                    <div>
                        <div class="meta-label">Max Score</div>
                        <div class="meta-value"><%= assignment.getMaxScore() %> points</div>
                    </div>
                </div>
                <% } %>
            </div>
            
            <h3 class="description-title">Description</h3>
            <div class="description-content">
                <%= assignment.getDescription() != null ? assignment.getDescription() : "No description provided for this assignment." %>
            </div>
            
            <% if (assignment.getResources() != null && !assignment.getResources().isEmpty()) { %>
            <div class="resources-section">
                <h3 class="description-title">Resources</h3>
                
                <% for (String resource : assignment.getResources().split(",")) { %>
                <div class="resource-item">
                    <i class="fas fa-file-alt resource-icon"></i>
                    <div class="resource-info">
                        <div class="resource-title"><%= resource.trim() %></div>
                        <div class="resource-meta">Supplementary material</div>
                    </div>
                    <a href="#" class="btn btn-secondary">
                        <i class="fas fa-download"></i>
                    </a>
                </div>
                <% } %>
            </div>
            <% } %>
            
            <div class="action-buttons">
                <% if (isStudent) { %>
                    <a href="submitAssignment.jsp?id=<%= assignment.getId() %>" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Submit Assignment
                    </a>
                <% } else { // Instructor actions %>
                    <a href="editAssignment.jsp?assignmentId=<%= assignment.getId() %>" class="btn btn-warning">
                        <i class="fas fa-edit"></i> Edit Assignment
                    </a>
                    <a href="viewSubmissions.jsp?assignmentId=<%= assignment.getId() %>" class="btn btn-primary">
                        <i class="fas fa-eye"></i> View Submissions
                    </a>
                    <a href="DeleteAssignmentServlet?assignmentId=<%= assignment.getId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this assignment? This action cannot be undone.')">
                        <i class="fas fa-trash"></i> Delete Assignment
                    </a>
                <% } %>
                
                <a href="<%= isStudent ? "studentDashboard.jsp" : "instructorDashboard.jsp" %>" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
