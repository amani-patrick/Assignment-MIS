<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.submission.onlinesubmissionsystem_.model.Assignment, com.app.submission.onlinesubmissionsystem_.dao.AssignmentDAO, com.app.submission.onlinesubmissionsystem_.model.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.INSTRUCTOR) {
    response.sendRedirect("login.jsp");
    return;
  }

  int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
  AssignmentDAO assignmentDAO = new AssignmentDAO();
  Assignment assignment = assignmentDAO.getAssignmentById((long) assignmentId);

  if (assignment == null) {
    response.sendRedirect("instructorDashboard.jsp");
    return;
  }
  
  // Format the deadline for the datetime-local input
  String deadlineFormatted = assignment.getDeadline().atStartOfDay().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Assignment | EduSubmit</title>
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
    
    .edit-container {
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
        transition: all 0.3s ease;
    }
    
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    }
    
    .form-title {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
        background: linear-gradient(90deg, #FFFFFF, #00E5FF);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    
    .form-group {
        margin-bottom: 1.5rem;
    }
    
    .form-label {
        font-weight: 500;
        margin-bottom: 0.75rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .form-label i {
        color: var(--accent);
    }
    
    .form-control {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        color: var(--light);
        border-radius: 10px;
        padding: 12px;
        transition: all 0.3s ease;
    }
    
    .form-control:focus {
        background: rgba(255, 255, 255, 0.15);
        border-color: var(--accent);
        color: var(--light);
        box-shadow: 0 0 0 0.25rem rgba(0, 229, 255, 0.25);
    }
    
    .form-text {
        color: rgba(255, 255, 255, 0.7);
        font-size: 0.85rem;
        margin-top: 0.5rem;
    }
    
    textarea.form-control {
        min-height: 150px;
        resize: vertical;
    }
    
    .btn-container {
        display: flex;
        gap: 1rem;
        margin-top: 2rem;
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
    
    .btn-success {
        background: linear-gradient(45deg, #2ECC71, #27AE60);
        color: white;
        box-shadow: 0 8px 20px rgba(46, 204, 113, 0.3);
    }
    
    .btn-success:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 25px rgba(46, 204, 113, 0.4);
        background: linear-gradient(45deg, #27AE60, #2ECC71);
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
        <a class="navbar-brand" href="#">Edu<span>Submit</span> | Edit Assignment</a>
        <div>
            <a href="instructorDashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
    </div>
  </nav>

  <div class="container edit-container">
    <div class="card">
      <h2 class="form-title"><i class="fas fa-edit"></i> Edit Assignment</h2>
      <form action="UpdateAssignmentServlet" method="post">
        <input type="hidden" name="assignmentId" value="<%= assignment.getId() %>">

        <div class="form-group">
          <label for="title" class="form-label">
            <i class="fas fa-heading"></i> Title
          </label>
          <input type="text" name="title" id="title" class="form-control" value="<%= assignment.getTitle() %>" required>
          <div class="form-text">Update the title of your assignment.</div>
        </div>

        <div class="form-group">
          <label for="description" class="form-label">
            <i class="fas fa-align-left"></i> Description
          </label>
          <textarea name="description" id="description" class="form-control" required><%= assignment.getDescription() != null ? assignment.getDescription() : "" %></textarea>
          <div class="form-text">Edit the instructions for this assignment.</div>
        </div>

        <div class="form-group">
          <label for="deadline" class="form-label">
            <i class="far fa-calendar-alt"></i> Deadline
          </label>
          <input type="date" name="deadline" id="deadline" class="form-control" value="<%= deadlineFormatted %>" required>
          <div class="form-text">Update the submission deadline for this assignment.</div>
        </div>

        <% if (assignment.getMaxScore() > 0) { %>
        <div class="form-group">
          <label for="maxScore" class="form-label">
            <i class="fas fa-star"></i> Maximum Score
          </label>
          <input type="number" name="maxScore" id="maxScore" class="form-control" value="<%= assignment.getMaxScore() %>" min="0">
          <div class="form-text">Update the maximum possible score for this assignment.</div>
        </div>
        <% } %>

        <div class="btn-container">
          <button type="submit" class="btn btn-success">
            <i class="fas fa-save"></i> Update Assignment
          </button>
          <a href="viewSubmissions.jsp?assignmentId=<%= assignment.getId() %>" class="btn btn-secondary">
            <i class="fas fa-eye"></i> View Submissions
          </a>
          <a href="DeleteAssignmentServlet?assignmentId=<%= assignment.getId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this assignment? This action cannot be undone.')">
            <i class="fas fa-trash"></i> Delete
          </a>
        </div>
      </form>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // Set minimum date for deadline to today
    const deadlineInput = document.getElementById('deadline');
    const today = new Date().toISOString().split('T')[0];
    deadlineInput.min = today;
  </script>
</body>
</html>
