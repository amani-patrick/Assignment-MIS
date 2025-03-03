<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.submission.onlinesubmissionsystem_.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.INSTRUCTOR) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Assignment | EduSubmit</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4e54c8;
            --secondary-color: #8f94fb;
            --accent-color: #6c63ff;
            --text-color: #333;
            --light-text: #fff;
            --bg-dark: #2a2a2a;
            --bg-light: #f5f5f5;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --card-bg: rgba(255, 255, 255, 0.9);
            --shadow-color: rgba(0, 0, 0, 0.1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            color: var(--text-color);
        }
        
        .navbar {
            background-color: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 1rem 0;
            margin-bottom: 2rem;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--light-text);
            text-decoration: none;
        }
        
        .navbar-brand span {
            color: var(--accent-color);
            font-weight: 800;
        }
        
        .create-container {
            flex: 1;
            padding: 2rem 0;
            max-width: 800px;
            animation: fadeIn 0.5s ease-in-out;
        }
        
        .card {
            background: var(--card-bg);
            border-radius: 15px;
            box-shadow: 0 8px 30px var(--shadow-color);
            padding: 2rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            margin-bottom: 2rem;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
        }
        
        .form-title {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--primary-color);
        }
        
        .form-control {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 1px solid rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(108, 99, 255, 0.25);
            outline: none;
        }
        
        .btn {
            padding: 0.7rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(to right, var(--primary-color), var(--accent-color));
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(78, 84, 200, 0.4);
        }
        
        .btn-secondary {
            background-color: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: var(--light-text);
        }
        
        .btn-secondary:hover {
            background-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-3px);
        }
        
        .btn-container {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            justify-content: center;
        }
        
        .advanced-options-toggle {
            background-color: rgba(78, 84, 200, 0.1);
            color: var(--primary-color);
            padding: 0.8rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            margin-bottom: 1rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.3s;
        }
        
        .advanced-options-toggle:hover {
            background-color: rgba(78, 84, 200, 0.2);
        }
        
        .advanced-options {
            background-color: rgba(245, 245, 245, 0.7);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid rgba(0, 0, 0, 0.05);
            display: none;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 0 1.5rem;
            }
            
            .card {
                padding: 1.5rem;
            }
            
            .btn-container {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar">
    <div class="container">
        <a class="navbar-brand" href="#">Edu<span>Submit</span> | Create Assignment</a>
        <div>
            <a href="instructorDashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
    </div>
</nav>

<div class="container create-container">
    <div class="card">
        <h2 class="form-title"><i class="fas fa-plus-circle"></i> Create New Assignment</h2>
        <form action="createAssignment" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title" class="form-label">
                    <i class="fas fa-heading"></i> Title
                </label>
                <input type="text" class="form-control" id="title" name="title" required placeholder="Enter assignment title">
            </div>

            <div class="form-group">
                <label for="description" class="form-label">
                    <i class="fas fa-align-left"></i> Description
                </label>
                <textarea class="form-control" id="description" name="description" required placeholder="Enter assignment instructions and details"></textarea>
            </div>

            <div class="form-group">
                <label for="deadline" class="form-label">
                    <i class="far fa-calendar-alt"></i> Deadline
                </label>
                <input type="datetime-local" class="form-control" id="deadline" name="deadline" required>
            </div>

            <div class="advanced-options-toggle" id="advanced-toggle">
                <i class="fas fa-cog"></i> Advanced Options
            </div>

            <div class="advanced-options" id="advanced-options">
                <div class="form-group">
                    <label for="maxScore" class="form-label">
                        <i class="fas fa-star"></i> Maximum Score
                    </label>
                    <input type="number" class="form-control" id="maxScore" name="maxScore" min="0" placeholder="Enter maximum points (optional)">
                </div>

                <div class="form-group">
                    <label for="resources" class="form-label">
                        <i class="fas fa-paperclip"></i> Resources (Optional)
                    </label>
                    <textarea class="form-control" id="resources" name="resources" placeholder="Enter resource links, one per line"></textarea>
                    <small class="form-text text-muted">Add useful links for students (e.g., reference materials, tutorials)</small>
                </div>
                
                <div class="form-group">
                    <label for="assignmentFile" class="form-label">
                        <i class="fas fa-file-upload"></i> Assignment File (Optional)
                    </label>
                    <input type="file" class="form-control" id="assignmentFile" name="assignmentFile">
                    <small class="form-text text-muted">Upload any related files (PDF, DOCX, etc.)</small>
                </div>
            </div>

            <div class="btn-container">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Create Assignment
                </button>
                <a href="instructorDashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toggle advanced options
    document.getElementById('advanced-toggle').addEventListener('click', function() {
        const advancedOptions = document.getElementById('advanced-options');
        if (advancedOptions.style.display === 'block') {
            advancedOptions.style.display = 'none';
        } else {
            advancedOptions.style.display = 'block';
        }
    });
    
    // Ensure deadline is not set to a past date
    const deadlineInput = document.getElementById('deadline');
    
    // Set minimum date to today
    const today = new Date();
    const formattedDate = today.toISOString().slice(0, 16);
    deadlineInput.setAttribute('min', formattedDate);
    
    // Set default value to tomorrow
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(23, 59);
    deadlineInput.value = tomorrow.toISOString().slice(0, 16);
</script>
</body>
</html>
