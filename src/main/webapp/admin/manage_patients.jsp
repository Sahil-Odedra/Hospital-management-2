<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<Patient> patients = hospitalDAO.getAllPatients();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Patient Directory | CareConnect</title>
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
                                            <h2 class="mb-1">Patient Records</h2>
                                            <p class="text-secondary small mb-0">Maintain and manage patient database
                                            </p>
                                        </div>
                                    </header>

                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success border-0 shadow-sm mb-4 animate-fade">
                                            <i data-lucide="check-circle" class="me-2"
                                                style="width: 18px; height: 18px;"></i>
                                            <%= request.getParameter("success") %>
                                        </div>
                                        <% } %>
                                            <% if (request.getParameter("error") !=null) { %>
                                                <div class="alert alert-danger border-0 shadow-sm mb-4 animate-fade">
                                                    <i data-lucide="alert-circle" class="me-2"
                                                        style="width: 18px; height: 18px;"></i>
                                                    <%= request.getParameter("error") %>
                                                </div>
                                                <% } %>

                                                    <div class="row g-4 animate-fade" style="animation-delay: 0.1s;">
                                                        <!-- List Patients -->
                                                        <div class="col-lg-8">
                                                            <div class="card border-0 shadow-sm h-100"
                                                                style="border-radius: var(--radius-xl);">
                                                                <div class="card-header bg-white py-3 border-0">
                                                                    <h5 class="mb-0 fw-semibold">Patient Registry</h5>
                                                                </div>
                                                                <div class="card-body p-0">
                                                                    <div class="table-responsive">
                                                                        <table
                                                                            class="table table-hover align-middle mb-0">
                                                                            <thead class="bg-light">
                                                                                <tr>
                                                                                    <th
                                                                                        class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                        PATIENT NAME</th>
                                                                                    <th
                                                                                        class="py-3 text-secondary small fw-semibold">
                                                                                        CONTACT INFO</th>
                                                                                    <th
                                                                                        class="py-3 text-secondary small fw-semibold">
                                                                                        DATE OF BIRTH</th>
                                                                                    <th
                                                                                        class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                        STATUS</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <% for(Patient p : patients) { %>
                                                                                    <tr>
                                                                                        <td class="ps-4">
                                                                                            <div
                                                                                                class="d-flex align-items-center gap-3">
                                                                                                <div class="bg-primary-subtle text-primary rounded-circle d-flex align-items-center justify-content-center"
                                                                                                    style="width: 40px; height: 40px;">
                                                                                                    <i data-lucide="user"
                                                                                                        style="width: 20px; height: 20px;"></i>
                                                                                                </div>
                                                                                                <span
                                                                                                    class="fw-medium text-dark">
                                                                                                    <%= p.getFullName()
                                                                                                        %>
                                                                                                </span>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td>
                                                                                            <div
                                                                                                class="small fw-medium">
                                                                                                <%= p.getEmail() %>
                                                                                            </div>
                                                                                            <div
                                                                                                class="text-secondary small">
                                                                                                <%= p.getPhone() %>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td
                                                                                            class="text-secondary small">
                                                                                            <i data-lucide="calendar"
                                                                                                class="me-1"
                                                                                                style="width: 14px; height: 14px;"></i>
                                                                                            <%= p.getDob() %>
                                                                                        </td>
                                                                                        <td class="text-end pe-4">
                                                                                            <span
                                                                                                class="badge bg-success-subtle text-success px-2 py-1">Active</span>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <% } %>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Add Patient Form -->
                                                        <div class="col-lg-4">
                                                            <div class="card border-0 shadow-sm"
                                                                style="border-radius: var(--radius-xl);">
                                                                <div class="card-header bg-white py-3 border-0">
                                                                    <h5 class="mb-0 fw-semibold">Register New Patient
                                                                    </h5>
                                                                </div>
                                                                <div class="card-body">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/admin/addPatient"
                                                                        method="POST">
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Full
                                                                                Name</label>
                                                                            <input type="text" name="fullName"
                                                                                class="form-control"
                                                                                placeholder="John Smith" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Email
                                                                                Address</label>
                                                                            <input type="email" name="email"
                                                                                class="form-control"
                                                                                placeholder="john@example.com" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Phone
                                                                                Number</label>
                                                                            <input type="text" name="phone"
                                                                                class="form-control"
                                                                                placeholder="+1 (555) 000-0000"
                                                                                required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Date
                                                                                of Birth</label>
                                                                            <input type="date" name="dob"
                                                                                class="form-control"
                                                                                max="<%= java.time.LocalDate.now() %>"
                                                                                required>
                                                                        </div>
                                                                        <button type="submit"
                                                                            class="btn btn-primary w-100 py-2 mt-2">
                                                                            <i data-lucide="user-plus" class="me-1"
                                                                                style="width: 18px; height: 18px;"></i>
                                                                            Register Patient
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