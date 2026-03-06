<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO dao=new
                HospitalDAO(); int doctorCount=dao.getDoctorCount(); int patientCount=dao.getPatientCount(); int
                pendingCount=dao.getPendingAppointmentCount(); int medicineCount=dao.getMedicineCount(); %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Dashboard | CareConnect Admin</title>
                    <!-- CSS Dependencies -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    <!-- Icons -->
                    <script src="https://unpkg.com/lucide@latest"></script>
                </head>

                <body>
                    <div class="d-flex">
                        <!-- Sidebar Navigation -->
                        <%@ include file="sidebar.jsp" %>

                            <!-- Main Workspace -->
                            <main class="main-content flex-grow-1">
                                <header class="d-flex justify-content-between align-items-center mb-5 animate-fade">
                                    <div>
                                        <h2 class="mb-1">Hello, <%= user.getFullName() %>
                                        </h2>
                                    </div>
                                </header>

                                <!-- Dashboard Stats Grid -->
                                <div class="row g-4 animate-fade" style="animation-delay: 0.1s;">
                                    <div class="col-md-3">
                                        <div class="stat-card h-100">
                                            <div class="stat-icon" style="background: #eff6ff; color: #1d4ed8;">
                                                <i data-lucide="user-plus"></i>
                                            </div>
                                            <h4 class="text-secondary small fw-medium mb-1">Total Doctors</h4>
                                            <div class="d-flex align-items-baseline gap-2">
                                                <h2 class="mb-0">
                                                    <%= doctorCount %>
                                                </h2>
                                                <span class="text-success small fw-medium"><i data-lucide="trending-up"
                                                        style="width: 14px; height: 14px;"></i> Active</span>
                                            </div>
                                            <hr class="my-3 opacity-50">
                                            <a href="manage_doctors.jsp"
                                                class="btn btn-link p-0 text-decoration-none small fw-medium d-flex align-items-center gap-1">
                                                Manage Directory <i data-lucide="chevron-right"
                                                    style="width: 14px; height: 14px;"></i>
                                            </a>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="stat-card h-100">
                                            <div class="stat-icon" style="background: #fdf2f7; color: #be185d;">
                                                <i data-lucide="contacts"></i>
                                            </div>
                                            <h4 class="text-secondary small fw-medium mb-1">Total Patients</h4>
                                            <div class="d-flex align-items-baseline gap-2">
                                                <h2 class="mb-0">
                                                    <%= patientCount %>
                                                </h2>
                                                <span class="text-muted small">Registered</span>
                                            </div>
                                            <hr class="my-3 opacity-50">
                                            <a href="manage_patients.jsp"
                                                class="btn btn-link p-0 text-decoration-none small fw-medium d-flex align-items-center gap-1"
                                                style="color: #be185d;">
                                                Patient Records <i data-lucide="chevron-right"
                                                    style="width: 14px; height: 14px;"></i>
                                            </a>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="stat-card h-100">
                                            <div class="stat-icon" style="background: #fffbeb; color: #b45309;">
                                                <i data-lucide="clock"></i>
                                            </div>
                                            <h4 class="text-secondary small fw-medium mb-1">Pending Appointments</h4>
                                            <div class="d-flex align-items-baseline gap-2">
                                                <h2 class="mb-0">
                                                    <%= pendingCount %>
                                                </h2>
                                                <span
                                                    class="badge bg-warning-subtle text-warning-emphasis small px-2">Action
                                                    Required</span>
                                            </div>
                                            <hr class="my-3 opacity-50">
                                            <a href="assign_appointment.jsp"
                                                class="btn btn-link p-0 text-decoration-none small fw-medium d-flex align-items-center gap-1"
                                                style="color: #b45309;">
                                                View Schedule <i data-lucide="chevron-right"
                                                    style="width: 14px; height: 14px;"></i>
                                            </a>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="stat-card h-100">
                                            <div class="stat-icon" style="background: #f0fdf4; color: #15803d;">
                                                <i data-lucide="pill"></i>
                                            </div>
                                            <h4 class="text-secondary small fw-medium mb-1">Pharmacy Inventory</h4>
                                            <div class="d-flex align-items-baseline gap-2">
                                                <h2 class="mb-0">
                                                    <%= medicineCount %>
                                                </h2>
                                                <span class="text-success small fw-medium">Medicines in Stock</span>
                                            </div>
                                            <hr class="my-3 opacity-50">
                                            <a href="manage_medicines.jsp"
                                                class="btn btn-link p-0 text-decoration-none small fw-medium d-flex align-items-center gap-1"
                                                style="color: #15803d;">
                                                View Stock <i data-lucide="chevron-right"
                                                    style="width: 14px; height: 14px;"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <!-- Quick Actions Section -->
                                <div class="mt-5 animate-fade" style="animation-delay: 0.2s;">
                                    <h5 class="mb-4">Quick Operations</h5>
                                    <div class="row g-3">
                                        <div class="col-sm-6 col-lg-3">
                                            <a href="manage_doctors.jsp"
                                                class="btn btn-white w-100 py-3 text-start glass shadow-sm d-flex align-items-center gap-3 border text-decoration-none">
                                                <div class="rounded p-2 bg-primary-subtle text-primary">
                                                    <i data-lucide="plus-circle"></i>
                                                </div>
                                                <span class="fw-medium text-dark">Add New Doctor</span>
                                            </a>
                                        </div>
                                        <div class="col-sm-6 col-lg-3">
                                            <a href="manage_patients.jsp"
                                                class="btn btn-white w-100 py-3 text-start glass shadow-sm d-flex align-items-center gap-3 border text-decoration-none">
                                                <div class="rounded p-2 bg-success-subtle text-success">
                                                    <i data-lucide="user-plus"></i>
                                                </div>
                                                <span class="fw-medium text-dark">Register Patient</span>
                                            </a>
                                        </div>
                                        <div class="col-sm-6 col-lg-3">
                                            <a href="assign_appointment.jsp"
                                                class="btn btn-white w-100 py-3 text-start glass shadow-sm d-flex align-items-center gap-3 border text-decoration-none">
                                                <div class="rounded p-2 bg-info-subtle text-info">
                                                    <i data-lucide="calendar-plus"></i>
                                                </div>
                                                <span class="fw-medium text-dark">Assign Appointment</span>
                                            </a>
                                        </div>
                                        <div class="col-sm-6 col-lg-3">
                                            <a href="manage_medicines.jsp"
                                                class="btn btn-white w-100 py-3 text-start glass shadow-sm d-flex align-items-center gap-3 border text-decoration-none">
                                                <div class="rounded p-2 bg-warning-subtle text-warning-emphasis">
                                                    <i data-lucide="flask-conical"></i>
                                                </div>
                                                <span class="fw-medium text-dark">Add Medicine</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </main>
                    </div>

                    <!-- Scripts -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        lucide.createIcons();
                    </script>
                </body>

                </html>