<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error | EduSubmit</title>
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
            display: flex;
            flex-direction: column;
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
        
        .error-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
            animation: fadeIn 0.8s ease forwards;
        }
        
        .error-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            padding: 3rem;
            text-align: center;
            max-width: 600px;
            width: 90%;
            transition: all 0.3s ease;
        }
        
        .error-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }
        
        .error-icon {
            font-size: 4rem;
            color: var(--warning);
            margin-bottom: 1.5rem;
            animation: pulse 2s infinite;
        }
        
        .error-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            background: linear-gradient(90deg, #FFFFFF, #00E5FF);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .error-message {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 2rem;
            font-size: 1.1rem;
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
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="#">Edu<span>Submit</span></a>
        </div>
    </nav>

    <div class="error-container">
        <div class="error-card">
            <i class="fas fa-exclamation-triangle error-icon"></i>
            <h1 class="error-title">
                <%= request.getAttribute("errorTitle") != null ? 
                    request.getAttribute("errorTitle") : "Oops! Something went wrong" %>
            </h1>
            <p class="error-message">
                <%= request.getAttribute("errorMessage") != null ? 
                    request.getAttribute("errorMessage") : "An unexpected error occurred. Please try again later." %>
            </p>
            <a href="<%= request.getAttribute("redirectUrl") != null ? 
                request.getAttribute("redirectUrl") : "index.jsp" %>" 
               class="btn btn-primary">
                <i class="fas fa-home"></i>
                <%= request.getAttribute("buttonText") != null ? 
                    request.getAttribute("buttonText") : "Return to Home" %>
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 