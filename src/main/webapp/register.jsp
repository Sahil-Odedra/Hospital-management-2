<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Patient Registration | CareConnect</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            :root {
                --primary: #3b82f6;
                --primary-dark: #2563eb;
                --bg: #f8fafc;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--bg);
                color: #1e293b;
            }

            .register-container {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 2rem;
            }

            .register-card {
                background: white;
                padding: 3rem;
                border-radius: 1.5rem;
                box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1);
                width: 100%;
                max-width: 600px;
            }

            .form-control,
            .form-select {
                padding: 0.75rem 1rem;
                border-radius: 0.75rem;
                border: 1px solid #e2e8f0;
                background-color: #f8fafc;
            }

            .form-control:focus {
                box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
                border-color: var(--primary);
            }

            .btn-primary {
                background-color: var(--primary);
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 0.75rem;
                font-weight: 600;
                transition: all 0.2s;
            }

            .btn-primary:hover {
                background-color: var(--primary-dark);
                transform: translateY(-1px);
            }
        </style>
    </head>

    <body>
        <div class="register-container">
            <div class="register-card">
                <div class="text-center mb-5">
                    <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-circle mb-3"
                        style="width: 64px; height: 64px;">
                        <i data-lucide="user-plus" style="width: 32px; height: 32px;"></i>
                    </div>
                    <h2 class="fw-bold">Patient Portal</h2>
                    <p class="text-secondary">Register to join CareConnect Hospital Network</p>
                </div>

                <form action="${pageContext.request.contextPath}/admin/addPatient" method="POST">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Full Name</label>
                            <input type="text" name="fullName" class="form-control" placeholder="John Doe" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Email Address</label>
                            <input type="email" name="email" class="form-control" placeholder="john@example.com">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Phone Number</label>
                            <input type="tel" name="phone" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Date of Birth</label>
                            <input type="date" name="dob" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Gender</label>
                            <select name="gender" class="form-select">
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Blood Group</label>
                            <select name="bloodGroup" class="form-select">
                                <option value="A+">A+</option>
                                <option value="B+">B+</option>
                                <option value="AB+">AB+</option>
                                <option value="O+">O+</option>
                                <option value="A-">A-</option>
                                <option value="B-">B-</option>
                                <option value="AB-">AB-</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Allergies</label>
                            <input type="text" name="allergies" class="form-control" placeholder="e.g. Penicillin">
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Full Address</label>
                            <textarea name="address" class="form-control" rows="2"
                                placeholder="Street, City, Pincode"></textarea>
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary w-100 py-3">
                            Complete Registration
                        </button>
                    </div>

                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/index.jsp"
                            class="text-decoration-none small text-secondary">
                            Already have an account? Sign in
                        </a>
                    </div>
                </form>
            </div>
        </div>
        <script>lucide.createIcons();</script>
    </body>

    </html>