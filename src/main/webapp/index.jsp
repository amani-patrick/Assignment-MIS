<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduSubmit | Modern Assignment Submission Platform</title>
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
        }
        
        .navbar {
            background: rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--light);
        }
        
        .navbar-brand span {
            color: var(--secondary);
        }
        
        .nav-link {
            color: var(--light);
            margin: 0 0.5rem;
            position: relative;
            transition: 0.3s;
        }
        
        .nav-link:hover {
            color: var(--accent);
        }
        
        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background-color: var(--accent);
            transition: width 0.3s ease;
        }
        
        .nav-link:hover::after {
            width: 100%;
        }
        
        .hero-section {
            min-height: 85vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 70% 30%, rgba(98, 0, 234, 0.2) 0%, transparent 70%);
            z-index: -1;
        }
        
        .hero-section::after {
            content: '';
            position: absolute;
            bottom: -10%;
            right: -10%;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(255, 64, 129, 0.2) 0%, transparent 70%);
            z-index: -1;
            animation: pulse 10s infinite alternate;
        }
        
        .hero-title {
            font-weight: 800;
            font-size: 3.5rem;
            line-height: 1.2;
            margin-bottom: 1.5rem;
            background: linear-gradient(90deg, #FFFFFF, #00E5FF);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease forwards 0.3s;
        }
        
        .tagline {
            font-size: 1.2rem;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease forwards 0.6s;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .cta-section {
            margin-top: 2.5rem;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease forwards 0.9s;
        }
        
        .btn-custom-primary {
            background: linear-gradient(45deg, var(--secondary), #FF7E97);
            color: white;
            border: none;
            padding: 14px 36px;
            border-radius: 50px;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 8px 20px rgba(255, 64, 129, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .btn-custom-primary::before {
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
        
        .btn-custom-primary:hover::before {
            left: 0;
        }
        
        .btn-custom-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(255, 64, 129, 0.4);
            color: white;
        }
        
        .btn-custom-secondary {
            background: transparent;
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 14px 36px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-custom-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.6);
            color: white;
        }
        
        .hero-image-container {
            position: relative;
        }
        
        .blob {
            position: absolute;
            width: 120%;
            height: 120%;
            top: -10%;
            left: -10%;
            background: linear-gradient(45deg, var(--primary), var(--accent));
            border-radius: 30% 70% 70% 30% / 30% 40% 60% 70%;
            animation: blobAnimation 10s ease-in-out infinite alternate;
            opacity: 0.5;
            z-index: -1;
        }
        
        .hero-image {
            max-width: 100%;
            border-radius: 10px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            opacity: 0;
            transform: translateX(20px);
            animation: fadeInRight 0.8s ease forwards 0.9s;
            position: relative;
            z-index: 1;
        }
        
        .features-section {
            margin-top: 5rem;
            padding: 5rem 0;
            background: rgba(255, 255, 255, 0.03);
            position: relative;
            overflow: hidden;
        }
        
        .features-section::before {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(0, 229, 255, 0.1) 0%, transparent 70%);
            top: -150px;
            left: -150px;
            z-index: 0;
        }
        
        .section-title {
            font-weight: 700;
            margin-bottom: 3rem;
            color: var(--light);
            position: relative;
            display: inline-block;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            width: 60px;
            height: 4px;
            background: var(--secondary);
            bottom: -10px;
            left: 0;
        }
        
        .feature-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 2.5rem 2rem;
            transition: all 0.4s ease;
            height: 100%;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .feature-card::before {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, transparent 100%);
            top: 0;
            left: 0;
            z-index: -1;
        }
        
        .feature-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            border-color: rgba(255, 255, 255, 0.2);
        }
        
        .feature-icon {
            font-size: 2.8rem;
            margin-bottom: 1.5rem;
            background: linear-gradient(45deg, var(--secondary), var(--accent));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: inline-block;
        }
        
        .testimonial-section {
            padding: 5rem 0;
            position: relative;
        }
        
        .testimonial-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            height: 100%;
            transition: all 0.3s ease;
        }
        
        .testimonial-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .quote {
            font-size: 1.2rem;
            font-style: italic;
            margin-bottom: 1.5rem;
            position: relative;
        }
        
        .quote::before {
            content: "";
            font-size: 4rem;
            position: absolute;
            left: -20px;
            top: -20px;
            opacity: 0.2;
            color: var(--secondary);
        }
        
        .testimonial-author {
            display: flex;
            align-items: center;
        }
        
        .author-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
        }
        
        .author-info h5 {
            margin: 0;
            font-weight: 600;
        }
        
        .author-info small {
            color: rgba(255, 255, 255, 0.7);
        }
        
        .stats-section {
            padding: 4rem 0;
        }
        
        .stat-item {
            text-align: center;
            padding: 2rem;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            background: linear-gradient(90deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .stat-label {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .footer {
            background: rgba(0, 0, 0, 0.3);
            padding: 2rem 0;
            margin-top: 3rem;
        }
        
        .social-icons a {
            color: var(--light);
            font-size: 1.5rem;
            margin: 0 10px;
            transition: all 0.3s ease;
        }
        
        .social-icons a:hover {
            color: var(--secondary);
            transform: translateY(-3px);
        }
        
        /* Animations */
        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInRight {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes blobAnimation {
            0% {
                border-radius: 30% 70% 70% 30% / 30% 40% 60% 70%;
            }
            25% {
                border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%;
            }
            50% {
                border-radius: 40% 60% 50% 50% / 30% 60% 40% 70%;
            }
            75% {
                border-radius: 30% 70% 70% 30% / 50% 40% 60% 50%;
            }
            100% {
                border-radius: 60% 40% 30% 70% / 30% 50% 70% 50%;
            }
        }
        
        @keyframes pulse {
            0% {
                opacity: 0.5;
                transform: scale(1);
            }
            50% {
                opacity: 0.7;
                transform: scale(1.05);
            }
            100% {
                opacity: 0.5;
                transform: scale(1);
            }
        }
        
        /* Responsive styles */
        @media (max-width: 991px) {
            .hero-title {
                font-size: 2.8rem;
            }
            
            .hero-section {
                min-height: auto;
                padding: 5rem 0;
            }
            
            .hero-image-container {
                margin-top: 3rem;
            }
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .feature-card, .testimonial-card {
                margin-bottom: 2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="#">Edu<span>Submit</span></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Contact</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="hero-title">Transform Your Academic Experience</h1>
                    <p class="lead tagline">EduSubmit streamlines your assignment workflow with a secure, intuitive platform designed for students and educators.</p>
                    
                    <div class="cta-section d-flex flex-wrap gap-3">
                        <a href="register.jsp" class="btn btn-custom-primary">Get Started <i class="fas fa-arrow-right ms-2"></i></a>
                        <a href="login.jsp" class="btn btn-custom-secondary">Sign In</a>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="hero-image-container mt-5 mt-lg-0">
                        <div class="blob"></div>
                        <img src="https://images.unsplash.com/photo-1516321497487-e288fb19713f?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Students collaborating digitally" class="hero-image img-fluid">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section">
        <div class="container">
            <h2 class="text-center section-title mb-5">Why Choose EduSubmit?</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <i class="fas fa-rocket feature-icon"></i>
                        <h3 class="mb-3">Speed & Efficiency</h3>
                        <p>Submit assignments in seconds, not minutes. Our streamlined process saves you valuable time and reduces submission stress.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <i class="fas fa-chart-line feature-icon"></i>
                        <h3 class="mb-3">Track Progress</h3>
                        <p>Monitor your submission history, grades, and instructor feedback all in one intuitive dashboard.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <i class="fas fa-shield-alt feature-icon"></i>
                        <h3 class="mb-3">Secure & Reliable</h3>
                        <p>Rest easy knowing your work is protected with enterprise-level security and backed up across multiple servers.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <div class="stat-item">
                        <div class="stat-number" data-count="5000">5,000+</div>
                        <div class="stat-label">Active Students</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-item">
                        <div class="stat-number" data-count="250">250+</div>
                        <div class="stat-label">Educational Institutions</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-item">
                        <div class="stat-number" data-count="98">98%</div>
                        <div class="stat-label">Satisfaction Rate</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonial-section">
        <div class="container">
            <h2 class="text-center section-title mb-5">What Our Users Say</h2>
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="testimonial-card">
                        <p class="quote">EduSubmit transformed how I manage my coursework. The interface is intuitive, and submitting assignments has never been easier!</p>
                        <div class="testimonial-author">
                            <img src="https://randomuser.me/api/portraits/women/45.jpg" alt="User" class="author-avatar">
                            <div class="author-info">
                                <h5>Sarah Johnson</h5>
                                <small>Computer Science Student</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="testimonial-card">
                        <p class="quote">As a professor, I appreciate how EduSubmit organizes submissions and makes grading more efficient. It's a game-changer for educators.</p>
                        <div class="testimonial-author">
                            <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="User" class="author-avatar">
                            <div class="author-info">
                                <h5>Dr. Michael Chen</h5>
                                <small>Professor of Engineering</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-md-0">© 2023 EduSubmit | Elevating Academic Submissions</p>
                </div>
                <div class="col-md-6">
                    <div class="social-icons text-center text-md-end">
                        <a href="#"><i class="fab fa-facebook"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                    </div>
                </div>
    </div>
</div>
    </footer>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Image fallback script -->
    <script>
        document.querySelector('.hero-image').addEventListener('error', function() {
            this.src = 'https://via.placeholder.com/800x600?text=EduSubmit+Platform';
        });
        
        document.querySelectorAll('.author-avatar').forEach(img => {
            img.addEventListener('error', function() {
                this.src = 'https://via.placeholder.com/50x50?text=User';
            });
        });
    </script>
</body>
</html>