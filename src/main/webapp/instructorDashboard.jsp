<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.app.submission.onlinesubmissionsystem_.model.Assignment, com.app.submission.onlinesubmissionsystem_.dao.AssignmentDAO, com.app.submission.onlinesubmissionsystem_.model.User, java.time.LocalDate, java.time.format.DateTimeFormatter, java.util.UUID" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.INSTRUCTOR) {
        response.sendRedirect("login.jsp");
        return;
    }

    AssignmentDAO assignmentDAO = new AssignmentDAO();
    List<Assignment> assignments = assignmentDAO.getAssignmentsByInstructor(user); // Show only instructor's assignments
    
    String notification = (String) session.getAttribute("notification");
    String notificationType = (String) session.getAttribute("notificationType");
    
    LocalDate today = LocalDate.now();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");

    String csrfToken = UUID.randomUUID().toString();
    session.setAttribute("csrfToken", csrfToken);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Dashboard | EduSubmit</title>
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
            --info: #03A9F4;
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
        
        .dashboard-container {
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
        
        .dashboard-header {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .welcome-text {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            background: linear-gradient(90deg, #FFFFFF, #00E5FF);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .user-name {
            font-weight: 700;
            color: var(--secondary);
        }
        
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            min-width: 300px;
            animation: slideIn 0.5s ease forwards;
        }
        
        .section-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        .create-btn-container {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 1.5rem;
        }
        
        .btn-create {
            background: linear-gradient(45deg, var(--primary), #7C4DFF);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 8px 20px rgba(98, 0, 234, 0.3);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }
        
        .btn-create:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(98, 0, 234, 0.4);
            color: white;
        }
        
        .section-title {
            font-weight: 600;
            margin-bottom: 1.5rem;
            position: relative;
            display: inline-block;
            padding-bottom: 0.5rem;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            width: 60px;
            height: 3px;
            background: var(--secondary);
            bottom: 0;
            left: 0;
        }
        
        /* Assignment Cards Styling */
        .assignment-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }
        
        .assignment-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex;
            flex-direction: column;
        }
        
        .assignment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }
        
        .assignment-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--light);
        }
        
        .assignment-description {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
            margin-bottom: 1rem;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        
        .assignment-details {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(0, 0, 0, 0.2);
            padding: 0.5rem 0.75rem;
            border-radius: 50px;
            font-size: 0.85rem;
        }
        
        .deadline-badge {
            background: linear-gradient(45deg, var(--primary), #7986CB);
        }
        
        .deadline-upcoming {
            background: linear-gradient(45deg, var(--warning), #FFA000);
            color: #000;
        }
        
        .deadline-overdue {
            background: linear-gradient(45deg, var(--danger), #C62828);
        }
        
        .score-badge {
            background: linear-gradient(45deg, var(--success), #2E7D32);
        }
        
        .submissions-badge {
            background: linear-gradient(45deg, var(--info), #0288D1);
        }
        
        .assignment-file {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(0, 0, 0, 0.1);
            padding: 0.75rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            transition: all 0.2s;
        }
        
        .assignment-file:hover {
            background: rgba(0, 0, 0, 0.2);
        }
        
        .assignment-file i {
            font-size: 1.5rem;
            color: var(--light);
        }
        
        .file-details {
            flex: 1;
        }
        
        .file-name {
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .file-size {
            font-size: 0.75rem;
            color: rgba(255, 255, 255, 0.6);
        }
        
        .download-btn {
            color: var(--light);
            background: rgba(0, 0, 0, 0.3);
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            text-decoration: none;
        }
        
        .download-btn:hover {
            background: var(--primary);
            transform: scale(1.1);
        }
        
        .resources-container {
            background: rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            padding: 0.75rem;
            margin-bottom: 1rem;
        }
        
        .resources-title {
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .resource-link {
            display: block;
            color: var(--accent);
            text-decoration: none;
            font-size: 0.85rem;
            padding: 0.25rem 0;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .resource-link:hover {
            color: var(--light);
            transform: translateX(5px);
        }
        
        .card-actions {
            display: flex;
            gap: 0.75rem;
            margin-top: auto;
            padding-top: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.85rem;
            text-decoration: none;
        }
        
        .btn-info {
            background: linear-gradient(45deg, var(--info), #29B6F6);
            color: white;
            box-shadow: 0 4px 15px rgba(3, 169, 244, 0.3);
        }
        
        .btn-info:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(3, 169, 244, 0.4);
            background: linear-gradient(45deg, #29B6F6, var(--info));
            color: white;
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
        
        .no-assignments {
            text-align: center;
            padding: 3rem;
        }
        
        .no-assignments i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.6;
        }
        
        .alert {
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .alert-success {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid rgba(76, 175, 80, 0.3);
            color: #81c784;
        }
        
        .alert-danger {
            background: rgba(244, 67, 54, 0.2);
            border: 1px solid rgba(244, 67, 54, 0.3);
            color: #e57373;
        }
        
        /* Animation keyframes */
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @media (max-width: 768px) {
            .assignment-cards {
                grid-template-columns: 1fr;
            }
            
            .card-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="#">Edu<span>Submit</span> | Instructor Dashboard</a>
            <div>
                <a href="logout" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </div>
        </div>
    </nav>
    
    <!-- Notification Alert -->
    <% if (notification != null && !notification.isEmpty()) { %>
    <div class="notification">
        <div class="alert alert-<%= notificationType.equals("success") ? "success" : "danger" %>">
            <i class="fas fa-<%= notificationType.equals("success") ? "check-circle" : "exclamation-circle" %> me-2"></i>
            <%= notification %>
        </div>
    </div>
    <%
        // Clear the notification after displaying it
        session.removeAttribute("notification");
        session.removeAttribute("notificationType");
    }
    %>

    <div class="container dashboard-container">
        <!-- Welcome Section -->
        <div class="dashboard-header">
            <h2 class="welcome-text">Instructor Dashboard</h2>
            <p class="lead">Welcome, <span class="user-name"><%= user.getName() %></span>! Manage your assignments and student submissions here.</p>
        </div>

        <!-- Assignments Section -->
        <div class="section-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="section-title">Your Assignments</h3>
                <a href="createAssignment.jsp" class="btn-create">
                    <i class="fas fa-plus-circle"></i> Create New Assignment
                </a>
            </div>
            
            <% if (assignments.isEmpty()) { %>
                <div class="no-assignments">
                    <i class="fas fa-clipboard-list"></i>
                    <h4>No Assignments Created</h4>
                    <p>You haven't created any assignments yet.</p>
                    <p>Get started by clicking the "Create New Assignment" button.</p>
                </div>
            <% } else { %>
                <div class="assignment-cards">
                    <% for (Assignment assignment : assignments) { 
                        boolean isOverdue = assignment.getDeadline().isBefore(today);
                        boolean isUpcoming = assignment.getDeadline().isEqual(today) || 
                                            (assignment.getDeadline().isAfter(today) && 
                                            assignment.getDeadline().isBefore(today.plusDays(3)));
                    %>
                        <div class="assignment-card">
                            <h4 class="assignment-title"><%= assignment.getTitle() %></h4>
                            
                            <div class="assignment-description">
                                <%= assignment.getDescription() %>
                            </div>
                            
                            <div class="assignment-details">
                                <div class="detail-item deadline-badge 
                                    <%= isOverdue ? "deadline-overdue" : (isUpcoming ? "deadline-upcoming" : "") %>">
                                    <i class="far fa-calendar-alt"></i>
                                    <%= assignment.getDeadline().format(dateFormatter) %>
                                    <% if(isOverdue) { %>
                                        <span class="ms-1">(Overdue)</span>
                                    <% } else if(isUpcoming) { %>
                                        <span class="ms-1">(Soon)</span>
                                    <% } %>
                                </div>
                                
                                <% if(assignment.getMaxScore() != null && assignment.getMaxScore() > 0) { %>
                                <div class="detail-item score-badge">
                                    <i class="fas fa-star"></i>
                                    Max: <%= assignment.getMaxScore() %> pts
                                </div>
                                <% } %>
                                
                                <div class="detail-item submissions-badge">
                                    <i class="fas fa-users"></i>
                                    <!-- This would need actual submission count from DAO -->
                                    Submissions
                                </div>
                            </div>
                            
                            <% if(assignment.getFilePath() != null && !assignment.getFilePath().isEmpty()) { %>
                            <div class="assignment-file">
                                <i class="fas fa-file-alt"></i>
                                <div class="file-details">
                                    <div class="file-name">Assignment Document</div>
                                    <div class="file-size">Click to download</div>
                                </div>
                                <a href="DownloadFileServlet?type=assignment&id=<%= assignment.getId() %>" class="download-btn">
                                    <i class="fas fa-download"></i>
                                </a>
                            </div>
                            <% } %>
                            
                            <% if(assignment.getResources() != null && !assignment.getResources().isEmpty()) { %>
                            <div class="resources-container">
                                <div class="resources-title">
                                    <i class="fas fa-link"></i> Resources & Materials
                                </div>
                                <% 
                                String[] resourceLinks = assignment.getResources().split("\\r?\\n");
                                for(String resource : resourceLinks) {
                                    if(resource != null && !resource.trim().isEmpty()) {
                                        String resourceTitle = resource;
                                        if(resource.length() > 40) {
                                            resourceTitle = resource.substring(0, 37) + "...";
                                        }
                                %>
                                <a href="<%= resource %>" target="_blank" class="resource-link">
                                    <i class="fas fa-external-link-alt"></i>
                                    <%= resourceTitle %>
                                </a>
                                <% 
                                    }
                                }
                                %>
                            </div>
                            <% } %>
                            
                            <div class="card-actions">
                                <form action="viewSubmissions.jsp" method="POST" style="display: inline;">
                                    <input type="hidden" name="assignmentId" value="<%= assignment.getId() %>">
                                    <input type="hidden" name="csrfToken" value="<%= csrfToken %>">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-eye"></i> View Submissions
                                    </button>
                                </form>
                                <a href="editAssignment.jsp?assignmentId=<%= assignment.getId() %>" class="btn btn-warning">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <a href="DeleteAssignmentServlet?assignmentId=<%= assignment.getId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this assignment? This action cannot be undone.')">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-dismiss the notification after 5 seconds
        setTimeout(function() {
            const notification = document.querySelector('.notification');
            if (notification) {
                notification.style.animation = 'slideOut 0.5s forwards';
                setTimeout(function() {
                    notification.remove();
                }, 500);
            }
        }, 5000);
        
        // Animate the notification slide out
        document.styleSheets[0].insertRule(`
            @keyframes slideOut {
                to {
                    transform: translateX(120%);
                    opacity: 0;
                }
            }
        `, document.styleSheets[0].cssRules.length);
        
        // Expand assignment description on click
        document.querySelectorAll('.assignment-description').forEach(desc => {
            desc.addEventListener('click', function() {
                if(this.style.webkitLineClamp === 'none') {
                    this.style.webkitLineClamp = '3';
                } else {
                    this.style.webkitLineClamp = 'none';
                }
            });
        });
    </script>
</body>
</html>
