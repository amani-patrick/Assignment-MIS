<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | EduSubmit</title>
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
        }
        
        .card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            color: var(--light);
            width: 380px;
            padding: 2rem !important;
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
        }
        
        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: var(--light);
            border-radius: 10px;
            padding: 12px;
            margin-bottom: 1rem;
        }
        
        .form-control:focus {
            background: rgba(255, 255, 255, 0.15);
            border-color: var(--accent);
            color: var(--light);
            box-shadow: 0 0 0 0.25rem rgba(0, 229, 255, 0.25);
        }
        
        label {
            color: var(--light);
            font-weight: 500;
            margin-bottom: 0.5rem;
            display: block;
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
            margin-top: 1rem;
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
        
        a {
            color: var(--accent);
            text-decoration: none;
            transition: all 0.3s ease;
            position: relative;
        }
        
        a::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background-color: var(--accent);
            transition: width 0.3s ease;
        }
        
        a:hover::after {
            width: 100%;
        }
        
        a:hover {
            color: var(--accent);
        }
        
        .alert-danger {
            background: rgba(220, 53, 69, 0.2);
            color: #ff8ca0;
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 10px;
            margin-bottom: 1.5rem;
        }
        
        p {
            margin-top: 1.5rem;
            text-align: center;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .form-group {
            margin-bottom: 1rem;
            text-align: right;
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
    <div class="card">
        <h2 class="text-center">Welcome Back</h2>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="login" method="post">
            <div class="mb-3">
                <label for="email">Email</label>
                <input type="email" class="form-control" id="email" name="email" required placeholder="Enter your email">
            </div>
            <div class="mb-3">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password" required placeholder="Enter your password">
            </div>
            <div class="form-group">
                <a href="login?action=forgotPassword">Forgot Password?</a>
            </div>
            <button type="submit" class="btn btn-primary w-100">
                Login <i class="fas fa-sign-in-alt ms-2"></i>
            </button>
        </form>
        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>
</body>
</html>
