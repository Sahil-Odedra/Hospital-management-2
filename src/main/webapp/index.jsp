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

    <body class="bg-light">
        <style>
            .login-container {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 24px;
                background-color: #f8fafc;
            }

            .login-card {
                width: 100%;
                max-width: 420px;
                background: #ffffff;
                padding: 48px;
                border-radius: 16px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
            }

            .login-logo {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                font-size: 1.75rem;
                font-weight: 700;
                margin-bottom: 2rem;
                color: #000000;
            }
        </style>

        <div class="login-container">
            <div class="login-card animate-fade">
                <div class="login-logo brand-font">
                    <i data-lucide="activity" style="width: 32px; height: 32px;"></i>
                    CareConnect
                </div>

                <% if (request.getParameter("error") !=null) { %>
                    <div class="alert alert-danger border-0 small py-2 mb-4" role="alert"
                        style="background: #fef2f2; color: #991b1b;">
                        <i data-lucide="alert-circle" style="width: 16px; height: 16px; margin-right: 4px;"></i>
                        <%= request.getParameter("error") %>
                    </div>
                    <% } %>

                        <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                            <div class="mb-4">
                                <label for="email" class="form-label small fw-medium text-secondary">Email
                                    Address</label>
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

                            <button type="submit" class="btn btn-primary w-100 py-3 fs-6 fw-semibold mt-2">Sign In to
                                Dashboard</button>
                        </form>
            </div>
        </div>

        <script>
            // Initialize Lucide icons
            lucide.createIcons();
        </script>
    </body>

    </html>