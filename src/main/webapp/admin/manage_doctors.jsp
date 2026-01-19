<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<User> doctors = hospitalDAO.getAllDoctors();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Manage Doctors | CareConnect</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        <script src="https://unpkg.com/lucide@latest"></script>
                    </head>

                    <body>
                        <div class="d-flex">
                            <%@ include file="sidebar.jsp" %>

                                <main class="main-content flex-grow-1">
                                    <header class="d-flex justify-content-between align-items-center mb-5 animate-fade">
                                        <div>
                                            <h2 class="mb-1">Doctor Management</h2>
                                            <p class="text-secondary small mb-0">Manage hospital medical staff and
                                                credentials</p>
                                        </div>
                                    </header>

                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success border-0 shadow-sm mb-4 animate-fade">
                                            <i data-lucide="check-circle" class="me-2"
                                                style="width: 18px; height: 18px;"></i>
                                            <%= request.getParameter("success") %>
                                        </div>
                                        <% } %>

                                            <div class="row g-4 animate-fade" style="animation-delay: 0.1s;">
                                                <!-- List Doctors -->
                                                <div class="col-lg-8">
                                                    <div class="card border-0 shadow-sm h-100"
                                                        style="border-radius: var(--radius-xl);">
                                                        <div class="card-header bg-white py-3 border-0">
                                                            <h5 class="mb-0 fw-semibold">Medical Staff Directory</h5>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover align-middle mb-0">
                                                                    <thead class="bg-light">
                                                                        <tr>
                                                                            <th
                                                                                class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                NAME</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                SPECIALIZATION</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                EMAIL</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                ACTIONS</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% for(User doc : doctors) { %>
                                                                            <tr>
                                                                                <td class="ps-4">
                                                                                    <div
                                                                                        class="d-flex align-items-center gap-3">
                                                                                        <div class="bg-primary-subtle text-primary rounded-circle d-flex align-items-center justify-content-center"
                                                                                            style="width: 40px; height: 40px;">
                                                                                            <i data-lucide="user"
                                                                                                style="width: 20px; height: 20px;"></i>
                                                                                        </div>
                                                                                        <span class="fw-medium">Dr. <%=
                                                                                                doc.getFullName() %>
                                                                                                </span>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <span
                                                                                        class="badge bg-info-subtle text-info-emphasis px-2 py-1">
                                                                                        <%= doc.getSpecialization() %>
                                                                                    </span>
                                                                                </td>
                                                                                <td class="text-secondary small">
                                                                                    <%= doc.getEmail() %>
                                                                                </td>
                                                                                <td class="text-end pe-4">
                                                                                    <button
                                                                                        class="btn btn-sm btn-light border-0"
                                                                                        title="Edit Profile">
                                                                                        <i data-lucide="edit-3"
                                                                                            style="width: 16px; height: 16px; color: var(--text-secondary);"></i>
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                            <% } %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add Doctor Form -->
                                                <div class="col-lg-4">
                                                    <div class="card border-0 shadow-sm"
                                                        style="border-radius: var(--radius-xl);">
                                                        <div class="card-header bg-white py-3 border-0">
                                                            <h5 class="mb-0 fw-semibold">Register New Doctor</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/addDoctor"
                                                                method="POST">
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Full
                                                                        Name</label>
                                                                    <input type="text" name="fullName"
                                                                        class="form-control" placeholder="Dr. John Doe"
                                                                        required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Specialization</label>
                                                                    <input type="text" name="specialization"
                                                                        class="form-control"
                                                                        placeholder="e.g. Cardiologist" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Login
                                                                        Email</label>
                                                                    <input type="email" name="email"
                                                                        class="form-control"
                                                                        placeholder="email@hospital.com" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Initial
                                                                        Password</label>
                                                                    <input type="password" name="password"
                                                                        class="form-control" required>
                                                                </div>
                                                                <button type="submit"
                                                                    class="btn btn-primary w-100 py-2 mt-2">
                                                                    <i data-lucide="plus-circle" class="me-1"
                                                                        style="width: 18px; height: 18px;"></i>
                                                                    Create Staff Account
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                </main>
                        </div>
                        <script>
                            lucide.createIcons();
                        </script>
                    </body>

                    </html>