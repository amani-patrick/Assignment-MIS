<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | EduSubmit</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        
        .container {
            max-width: 500px;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            color: var(--light);
            padding: 2rem;
            animation: fadeInUp 0.8s ease forwards;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }
        
        h2 {
            font-weight: 700;
            margin-bottom: 1.5rem;
            background: linear-gradient(90deg, #FFFFFF, #00E5FF);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-align: center;
        }
        
        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: var(--light);
            border-radius: 10px;
            padding: 12px;
        }
        
        .form-control:focus {
            background: rgba(255, 255, 255, 0.15);
            border-color: var(--accent);
            color: var(--light);
            box-shadow: 0 0 0 0.25rem rgba(0, 229, 255, 0.25);
        }
        
        .form-select {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: var(--light);
            border-radius: 10px;
            padding: 12px;
        }
        
        .form-select:focus {
            background-color: rgba(255, 255, 255, 0.15);
            border-color: var(--accent);
            color: var(--light);
            box-shadow: 0 0 0 0.25rem rgba(0, 229, 255, 0.25);
        }
        
        .form-label {
            color: var(--light);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, var(--secondary), #FF7E97);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 8px 20px rgba(255, 64, 129, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
            margin-top: 0.5rem;
        }
        
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, #FF7E97, var(--secondary));
            transition: all 0.4s;
            z-index: -1;
        }
        
        .btn-primary:hover::before {
            left: 0;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(255, 64, 129, 0.4);
            color: white;
        }
        
        .btn-link {
            color: var(--accent);
            text-decoration: none;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .btn-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background-color: var(--accent);
            transition: width 0.3s ease;
        }
        
        .btn-link:hover::after {
            width: 100%;
        }
        
        .btn-link:hover {
            color: var(--accent);
        }
        
        .alert-danger {
            background: rgba(220, 53, 69, 0.2);
            color: #ff8ca0;
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 10px;
            margin-bottom: 1.5rem;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Create Account</h2>
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="RegisterServlet" method="post">
                <div class="mb-3">
                    <label for="name" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="name" name="name" required placeholder="Enter your full name">
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required placeholder="Enter your email address">
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required placeholder="Create a strong password">
                </div>

                <div class="mb-4">
                    <label for="role" class="form-label">Role</label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="" disabled selected>Choose your role</option>
                        <option value="STUDENT">Student</option>
                        <option value="INSTRUCTOR">Instructor</option>
                    </select>
                </div>

                <div class="d-flex flex-wrap justify-content-between align-items-center mt-4">
                    <button type="submit" class="btn btn-primary">
                        Register <i class="fas fa-user-plus ms-2"></i>
                    </button>
                    <a href="login.jsp" class="btn btn-link mt-2 mt-md-0">Already have an account? Login</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
