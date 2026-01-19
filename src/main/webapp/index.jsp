<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CareConnect | Secure Portal</title>
        <!-- Fonts -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <!-- Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>
    </head>

    <body class="auth-wrapper">

        <div class="auth-card animate-fade">
            <div class="auth-logo brand-font">
                <i data-lucide="activity" style="width: 32px; height: 32px;"></i>
                CareConnect
            </div>

            <h5 class="text-center mb-4" style="color: var(--text-secondary); font-weight: 400;">Welcome Back</h5>

            <% if (request.getParameter("error") !=null) { %>
                <div class="alert alert-danger border-0 small py-2" role="alert"
                    style="background: #fef2f2; color: #991b1b;">
                    <i data-lucide="alert-circle" style="width: 16px; height: 16px; margin-right: 4px;"></i>
                    <%= request.getParameter("error") %>
                </div>
                <% } %>

                    <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                        <div class="mb-4">
                            <label for="email" class="form-label small fw-medium text-secondary">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0 py-2" style="color: #94a3b8;">
                                    <i data-lucide="mail" style="width: 18px; height: 18px;"></i>
                                </span>
                                <input type="email" class="form-control border-start-0 ps-0" id="email" name="email"
                                    required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label small fw-medium text-secondary">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0 py-2" style="color: #94a3b8;">
                                    <i data-lucide="lock" style="width: 18px; height: 18px;"></i>
                                </span>
                                <input type="password" class="form-control border-start-0 ps-0" id="password"
                                    name="password" required>
                            </div>
                        </div>

                        <div class="mb-4 d-flex justify-content-between align-items-center">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="remember">
                                <label class="form-check-label small text-secondary" for="remember">Remember me</label>
                            </div>
                            <a href="#" class="small text-decoration-none fw-medium"
                                style="color: var(--brand-primary);">Forgot Password?</a>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fs-6">Sign In to Dashboard</button>
                    </form>

                    <div class="text-center mt-5">
                        <p class="small text-muted mb-0">© 2026 CareConnect Medical Systems</p>
                        <p class="small text-muted">A Secure & HIPAA Compliant Platform</p>
                    </div>
        </div>

        <script>
            // Initialize Lucide icons
            lucide.createIcons();
        </script>
    </body>

    </html>