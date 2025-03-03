<%@ page import="java.util.List, com.app.submission.onlinesubmissionsystem_.model.Assignment, com.app.submission.onlinesubmissionsystem_.model.Submission, com.app.submission.onlinesubmissionsystem_.dao.AssignmentDAO, com.app.submission.onlinesubmissionsystem_.dao.SubmissionDAO, com.app.submission.onlinesubmissionsystem_.model.User, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.STUDENT) {
        response.sendRedirect("login.jsp");
        return;
    }

    AssignmentDAO assignmentDAO = new AssignmentDAO();
    SubmissionDAO submissionDAO = new SubmissionDAO();
    List<Assignment> assignments = assignmentDAO.getAllAssignments();

    String notification = (String) session.getAttribute("notification");
    String notificationType = (String) session.getAttribute("notificationType");
    
    LocalDate today = LocalDate.now();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | EduSubmit</title>
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
        
        /* Assignment Card Styling */
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
            position: relative;
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
        }
        
        .download-btn:hover {
            background: var(--primary);
            transform: scale(1.1);
        }
        
        .submission-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            font-weight: 500;
        }
        
        .status-submitted {
            color: var(--success);
        }
        
        .status-not-submitted {
            color: var(--danger);
        }
        
        .submission-controls {
            margin-top: auto;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 1rem;
        }
        
        .file-input-container {
            position: relative;
            display: block;
            margin-bottom: 0.75rem;
        }
        
        .file-input {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: var(--light);
            border-radius: 10px;
            padding: 0.5rem;
            width: 100%;
            font-size: 0.85rem;
        }
        
        .file-input::-webkit-file-upload-button {
            background: rgba(0, 0, 0, 0.2);
            color: var(--light);
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
        }
        
        .btn {
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            font-size: 0.9rem;
        }
        
        .btn-success {
            background: linear-gradient(45deg, #2ECC71, #26A65B);
            color: white;
            box-shadow: 0 4px 15px rgba(46, 204, 113, 0.3);
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(46, 204, 113, 0.4);
            background: linear-gradient(45deg, #26A65B, #2ECC71);
        }
        
        .btn-danger {
            background: linear-gradient(45deg, #F44336, #D32F2F);
            color: white;
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.3);
        }
        
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(244, 67, 54, 0.4);
            background: linear-gradient(45deg, #D32F2F, #F44336);
        }
        
        .btn-view {
            background: linear-gradient(45deg, var(--primary), #7986CB);
            color: white;
            box-shadow: 0 4px 15px rgba(98, 0, 234, 0.3);
            padding: 0.3rem 1rem;
            border-radius: 50px;
            text-decoration: none;
            display: inline-block;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }
        
        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(98, 0, 234, 0.4);
            color: white;
            background: linear-gradient(45deg, #7986CB, var(--primary));
        }
        
        .btn-controls {
            display: flex;
            gap: 0.75rem;
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
        
        .no-assignments {
            text-align: center;
            padding: 3rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .no-assignments i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
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
            
            .btn-controls {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="#">Edu<span>Submit</span> | Student Dashboard</a>
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
            <h2 class="welcome-text">Welcome to your Dashboard</h2>
            <p class="lead">Hello, <span class="user-name"><%= user.getName() %></span>! Manage your assignments and submissions here.</p>
        </div>

        <!-- Assignments Section -->
            <h3 class="section-title">Available Assignments</h3>
            
        <% if (assignments.isEmpty()) { %>
            <div class="no-assignments">
                <i class="fas fa-book"></i>
                <h4>No Assignments Available</h4>
                <p>There are currently no assignments available. Check back later!</p>
            </div>
        <% } else { %>
            <div class="assignment-cards">
        <% for (Assignment assignment : assignments) {
            Submission submission = submissionDAO.getSubmissionByStudentAndAssignment(user.getId(), assignment.getId());
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
                            Max Score: <%= assignment.getMaxScore() %>
                        </div>
                        <% } %>
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
                    
                    <div class="submission-status">
                <% if (submission != null) { %>
                            <i class="fas fa-check-circle status-submitted"></i>
                            <span class="status-submitted">Submitted</span>
                            <a href="DownloadFileServlet?type=submission&id=<%= submission.getId() %>" target="_blank" class="btn-view ms-2">
                                <i class="fas fa-eye me-1"></i>View
                            </a>
                <% } else { %>
                            <i class="fas fa-times-circle status-not-submitted"></i>
                            <span class="status-not-submitted">Not Submitted</span>
                <% } %>
                    </div>
                    
                    <div class="submission-controls">
                        <form action="UploadSubmissionServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="assignmentId" value="<%= assignment.getId() %>">
                                <div class="file-input-container">
                                    <input type="file" name="file" class="file-input" required>
                                </div>
                            <div class="btn-controls">
                                    <button type="submit" class="btn btn-success">
                                    <i class="fas fa-upload me-2"></i>Submit
                                    </button>
                                    <% if (submission != null) { %>
                                        <a href="DeleteSubmissionServlet?submissionId=<%= submission.getId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this submission?')">
                                            <i class="fas fa-trash me-2"></i>Delete
                                        </a>
                                    <% } %>
                                </div>
                </form>
                    </div>
                </div>
                <% } %>
        </div>
        <% } %>
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
