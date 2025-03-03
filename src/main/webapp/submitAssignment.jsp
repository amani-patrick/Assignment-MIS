<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.submission.onlinesubmissionsystem_.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != com.app.submission.onlinesubmissionsystem_.model.Role.STUDENT) {
        response.sendRedirect("login.jsp");
        return;
    }

    String assignmentId = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Assignment | EduSubmit</title>
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
            align-items: center;
            justify-content: center;
        }
        
        .submit-container {
            max-width: 600px;
            width: 100%;
            animation: fadeIn 0.8s ease forwards;
            padding: 1rem;
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
        
        h2 {
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
        
        .form-label {
            color: var(--light);
            font-weight: 500;
            margin-bottom: 0.75rem;
            display: block;
        }
        
        .file-upload-container {
            position: relative;
            margin-bottom: 2rem;
        }
        
        .file-upload-box {
            background: rgba(255, 255, 255, 0.05);
            border: 2px dashed rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 2.5rem 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .file-upload-box:hover {
            border-color: var(--accent);
            background: rgba(255, 255, 255, 0.08);
        }
        
        .file-upload-icon {
            font-size: 2.5rem;
            color: var(--accent);
            margin-bottom: 1rem;
        }
        
        .file-upload-text {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 0.5rem;
        }
        
        .file-formats {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.6);
        }
        
        .file-input {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }
        
        .selected-file {
            background: rgba(76, 175, 80, 0.1);
            border: 1px solid rgba(76, 175, 80, 0.3);
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
            display: none;
            align-items: center;
            justify-content: space-between;
        }
        
        .selected-file-name {
            color: #81c784;
            font-size: 0.9rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 80%;
        }
        
        .selected-file-size {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.8rem;
        }
        
        .btn-container {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
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
            flex: 1;
            justify-content: center;
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
    </style>
</head>
<body>
    <div class="submit-container">
        <div class="card">
            <h2><i class="fas fa-cloud-upload-alt"></i> Submit Assignment</h2>
            
            <form action="uploadSubmission" method="post" enctype="multipart/form-data">
                <input type="hidden" name="assignmentId" value="<%= assignmentId %>">
                
                <div class="file-upload-container">
                    <label class="form-label">Upload Your Work</label>
                    <div class="file-upload-box" id="upload-box">
                        <i class="fas fa-file-upload file-upload-icon"></i>
                        <p class="file-upload-text">Drag and drop a file here or click to browse</p>
                        <p class="file-formats">Supported formats: PDF, Excel, PPTX, ZIP</p>
                        <input type="file" name="file" class="file-input" id="file-input" required>
                    </div>
                    
                    <div class="selected-file" id="selected-file">
                        <div>
                            <div class="selected-file-name" id="file-name"></div>
                            <div class="selected-file-size" id="file-size"></div>
                        </div>
                        <i class="fas fa-check-circle" style="color: #81c784;"></i>
                    </div>
                </div>
                
                <div class="btn-container">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Submit Assignment
                    </button>
                    <a href="studentDashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // File upload preview functionality
        const fileInput = document.getElementById('file-input');
        const uploadBox = document.getElementById('upload-box');
        const selectedFile = document.getElementById('selected-file');
        const fileName = document.getElementById('file-name');
        const fileSize = document.getElementById('file-size');
        
        fileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                const file = this.files[0];
                
                // Show selected file info
                fileName.textContent = file.name;
                fileSize.textContent = formatFileSize(file.size);
                selectedFile.style.display = 'flex';
                
                // Change upload box appearance
                uploadBox.style.borderColor = 'var(--success)';
            }
        });
        
        // Format file size to human-readable format
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }
        
        // Add drag and drop functionality
        uploadBox.addEventListener('dragover', function(e) {
            e.preventDefault();
            this.style.borderColor = 'var(--accent)';
            this.style.background = 'rgba(255, 255, 255, 0.1)';
        });
        
        uploadBox.addEventListener('dragleave', function(e) {
            e.preventDefault();
            this.style.borderColor = 'rgba(255, 255, 255, 0.2)';
            this.style.background = 'rgba(255, 255, 255, 0.05)';
        });
        
        uploadBox.addEventListener('drop', function(e) {
            e.preventDefault();
            this.style.borderColor = 'var(--success)';
            this.style.background = 'rgba(255, 255, 255, 0.05)';
            
            if (e.dataTransfer.files.length) {
                fileInput.files = e.dataTransfer.files;
                
                const file = e.dataTransfer.files[0];
                fileName.textContent = file.name;
                fileSize.textContent = formatFileSize(file.size);
                selectedFile.style.display = 'flex';
            }
        });
    </script>
</body>
</html>
