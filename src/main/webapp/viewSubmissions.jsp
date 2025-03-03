<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.submission.onlinesubmissionsystem_.dao.SubmissionDAO, com.app.submission.onlinesubmissionsystem_.dao.AssignmentDAO, com.app.submission.onlinesubmissionsystem_.model.Submission, com.app.submission.onlinesubmissionsystem_.model.Assignment, java.util.List" %>
<%@ page import="com.app.submission.onlinesubmissionsystem_.model.User, java.time.format.DateTimeFormatter" %>
<%
    // Add CSRF check
    String csrfToken = request.getParameter("csrfToken");
    String sessionToken = (String) session.getAttribute("csrfToken");
    
    if (csrfToken == null || !csrfToken.equals(sessionToken)) {
        response.sendRedirect("instructorDashboard.jsp");
        return;
    }
    
    // Clear the token after use
    session.removeAttribute("csrfToken");
    
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.INSTRUCTOR) {
        response.sendRedirect("login.jsp");
        return;
    }

    String assignmentId = request.getParameter("assignmentId");
    AssignmentDAO assignmentDAO = new AssignmentDAO();
    SubmissionDAO submissionDAO = new SubmissionDAO();

    Assignment assignment = null;
    List<Submission> submissions = null;
    String notification = null;
    String notificationType = null;
    String errorMessage = null;
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
    
    try {
        if (assignmentId == null || assignmentId.trim().isEmpty()) {
            errorMessage = "No assignment ID provided";
        } else {
            assignment = assignmentDAO.getAssignmentById(Long.parseLong(assignmentId));
            if (assignment == null) {
                errorMessage = "Assignment not found";
            } else {
                submissions = submissionDAO.getSubmissionsByAssignment(Long.parseLong(assignmentId));
            }
        }
        
        notification = (String) session.getAttribute("notification");
        notificationType = (String) session.getAttribute("notificationType");
    } catch (NumberFormatException e) {
        errorMessage = "Invalid assignment ID format";
    } catch (Exception e) {
        errorMessage = "Error loading assignment: " + e.getMessage();
    }

    if (assignment == null) {
        request.setAttribute("errorTitle", "Assignment Not Found");
        request.setAttribute("errorMessage", "The assignment you're trying to edit does not exist.");
        request.setAttribute("redirectUrl", "instructorDashboard.jsp");
        request.setAttribute("buttonText", "Return to Dashboard");
        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Submissions | EduSubmit</title>
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
        
        .page-container {
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
        
        .header-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .assignment-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            background: linear-gradient(90deg, #FFFFFF, #00E5FF);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .assignment-details {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
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
        
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            min-width: 300px;
            animation: slideIn 0.5s ease forwards;
        }
        
        .submissions-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
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
        
        .submission-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 1.5rem;
        }
        
        .submission-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 15px;
            padding: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex;
            flex-direction: column;
        }
        
        .submission-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
        }
        
        .student-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .student-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--primary), var(--accent));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--light);
        }
        
        .student-name {
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .student-email {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.7);
        }
        
        .submission-details {
            margin-bottom: 1rem;
        }
        
        .submission-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.85rem;
            background: rgba(0, 0, 0, 0.2);
            padding: 0.4rem 0.75rem;
            border-radius: 50px;
        }
        
        .status-badge {
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
        }
        
        .status-ontime {
            background: linear-gradient(45deg, var(--success), #2E7D32);
            color: white;
        }
        
        .status-late {
            background: linear-gradient(45deg, var(--danger), #C62828);
            color: white;
        }
        
        .file-container {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: rgba(0, 0, 0, 0.1);
            padding: 0.75rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            transition: all 0.2s;
        }
        
        .file-container:hover {
            background: rgba(0, 0, 0, 0.2);
        }
        
        .file-icon {
            font-size: 1.5rem;
            color: var(--light);
        }
        
        .file-info {
            flex: 1;
        }
        
        .file-name {
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .file-submitted {
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
        
        .grading-form {
            margin-top: auto;
            padding-top: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        
        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            padding: 0.5rem 1rem;
            color: var(--light);
            transition: all 0.2s;
        }
        
        .form-control:focus {
            background: rgba(255, 255, 255, 0.15);
            border-color: var(--accent);
            box-shadow: 0 0 0 0.25rem rgba(0, 229, 255, 0.25);
            color: var(--light);
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }
        
        .score-input {
            max-width: 100px;
        }
        
        .btn {
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, var(--primary), #7C4DFF);
            color: white;
            box-shadow: 0 4px 15px rgba(98, 0, 234, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(98, 0, 234, 0.4);
            background: linear-gradient(45deg, #7C4DFF, var(--primary));
            color: white;
        }
        
        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: var(--light);
        }
        
        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
            color: var(--light);
            transform: translateY(-2px);
        }
        
        .btn-success {
            background: linear-gradient(45deg, var(--success), #2E7D32);
            color: white;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(76, 175, 80, 0.4);
            background: linear-gradient(45deg, #2E7D32, var(--success));
            color: white;
        }
        
        .already-graded {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
            font-weight: 500;
            color: var(--success);
        }
        
        .no-submissions {
            text-align: center;
            padding: 3rem;
        }
        
        .no-submissions i {
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
            .submission-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="instructorDashboard.jsp">Edu<span>Submit</span> | Submissions</a>
            <div>
                <a href="instructorDashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
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
    
    <div class="container page-container">
        <% if (errorMessage != null) { %>
            <div class="header-container text-center">
                <i class="fas fa-exclamation-triangle text-warning" style="font-size: 3rem; margin-bottom: 1rem;"></i>
                <h2 class="assignment-title">Error</h2>
                <p class="text-light"><%= errorMessage %></p>
                <div class="mt-4">
                    <a href="instructorDashboard.jsp" class="btn btn-primary">
                        <i class="fas fa-home me-2"></i>Return to Dashboard
                    </a>
                </div>
            </div>
        <% } else { %>
            <!-- Assignment Header -->
            <div class="header-container">
                <h2 class="assignment-title"><%= assignment != null ? assignment.getTitle() : "Assignment Title" %></h2>
                <p><%= assignment != null ? assignment.getDescription() : "Assignment Description" %></p>
                
                <div class="assignment-details">
                    <div class="detail-item deadline-badge">
                        <i class="far fa-calendar-alt"></i>
                        Deadline: <%= assignment != null ? assignment.getDeadline().format(dateFormatter) : "No Deadline" %>
                    </div>
                    
                    <% if(assignment != null && assignment.getMaxScore() != null && assignment.getMaxScore() > 0) { %>
                    <div class="detail-item">
                        <i class="fas fa-star"></i>
                        Maximum Score: <%= assignment.getMaxScore() %> points
                    </div>
                    <% } %>
                    
                    <div class="detail-item">
                        <i class="fas fa-users"></i>
                        Submissions: <%= submissions != null ? submissions.size() : "No Submissions" %>
                    </div>
                </div>
            </div>
            
            <!-- Submissions Section -->
            <div class="submissions-container">
                <h3 class="section-title">Student Submissions</h3>
                
                <% if (submissions == null || submissions.isEmpty()) { %>
                    <div class="no-submissions">
                        <i class="fas fa-inbox"></i>
                        <h4>No Submissions Yet</h4>
                        <p>Students haven't submitted any work for this assignment yet.</p>
                    </div>
                <% } else { %>
                    <div class="submission-cards">
                        <% for (Submission submission : submissions) { 
                            boolean isOnTime = submission.getSubmittedAt().isBefore(assignment.getDeadline().atStartOfDay());
                            String studentInitial = submission.getStudent().getName().substring(0, 1).toUpperCase();
                        %>
                            <div class="submission-card">
                                <!-- Student Info -->
                                <div class="student-info">
                                    <div class="student-avatar">
                                        <%= studentInitial %>
                                    </div>
                                    <div>
                                        <div class="student-name"><%= submission.getStudent().getName() %></div>
                                        <div class="student-email"><%= submission.getStudent().getEmail() %></div>
                                    </div>
                                </div>
                                
                                <!-- Submission Details -->
                                <div class="submission-details">
                                    <div class="submission-meta">
                                        <div class="meta-item">
                                            <i class="far fa-clock"></i>
                                            Submitted: <%= submission.getSubmittedAt().format(dateFormatter) %>
                                        </div>
                                        
                                        <div class="status-badge <%= isOnTime ? "status-ontime" : "status-late" %>">
                                            <i class="fas <%= isOnTime ? "fa-check-circle" : "fa-exclamation-circle" %>"></i>
                                            <%= isOnTime ? "On Time" : "Late" %>
                                        </div>
                                    </div>
                                    
                                    <!-- File Download Section -->
                                    <% if (submission.getFilePath() != null && !submission.getFilePath().isEmpty()) { %>
                                        <div class="file-container">
                                            <i class="fas fa-file-alt file-icon"></i>
                                            <div class="file-info">
                                                <div class="file-name">
                                                    <%= submission.getFileName() != null ? 
                                                        submission.getFileName() : 
                                                        (submission.getFilePath() != null ? 
                                                            submission.getFilePath().substring(submission.getFilePath().lastIndexOf('/') + 1) : 
                                                            "Submission File") %>
                                                </div>
                                                <div class="file-submitted">
                                                    Submitted <%= submission.getSubmittedAt().format(dateFormatter) %>
                                                </div>
                                            </div>
                                            <form action="DownloadFileServlet" method="get" style="margin: 0;">
                                                <input type="hidden" name="submissionId" value="<%= submission.getId() %>">
                                                <button type="submit" class="download-btn" title="Download submission">
                                                    <i class="fas fa-download"></i>
                                                </button>
                                            </form>
                                        </div>
                                    <% } else { %>
                                        <div class="file-container" style="opacity: 0.5;">
                                            <i class="fas fa-file-alt file-icon"></i>
                                            <div class="file-info">
                                                <div class="file-name">No file submitted</div>
                                            </div>
                                        </div>
                                    <% } %>
                                    
                                    <!-- Score Display -->
                                    <% if (submission.getScore() != null) { %>
                                        <div class="score-display mt-3">
                                            <div class="meta-item">
                                                <i class="fas fa-star"></i>
                                                Score: <%= submission.getScore() %>
                                                <% if (assignment.getMaxScore() != null) { %>
                                                    / <%= assignment.getMaxScore() %>
                                                <% } %>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
</div>
    
    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-dismiss notification after 5 seconds
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
        
        // Toggle grade edit form
        function toggleGradeForm(submissionId) {
            const form = document.getElementById('grade-form-' + submissionId);
            if (form.style.display === 'none') {
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
            }
        }
    </script>
</body>
</html>
