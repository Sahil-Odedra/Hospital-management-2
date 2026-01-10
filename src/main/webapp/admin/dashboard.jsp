<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <title>Admin Dashboard</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                </head>

                <body>
                    <div class="d-flex">
                        <!-- Sidebar -->
                        <%@ include file="sidebar.jsp" %>

                            <!-- Main Content -->
                            <div class="flex-grow-1 p-4" style="margin-left: 280px;">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Welcome, <%= user.getFullName() %>
                                    </h2>
                                    <span class="badge bg-secondary">System Status: Online</span>
                                </div>

                                <% HospitalDAO dao=new HospitalDAO(); int doctorCount=dao.getDoctorCount(); int
                                    patientCount=dao.getPatientCount(); int
                                    pendingCount=dao.getPendingAppointmentCount(); %>

                                    <div class="row mt-4">
                                        <div class="col-md-4">
                                            <div class="card text-white bg-primary mb-3 h-100">
                                                <div class="card-header">Doctors</div>
                                                <div class="card-body">
                                                    <h1 class="display-4">
                                                        <%= doctorCount %>
                                                    </h1>
                                                    <p class="card-text">Total Registered Doctors</p>
                                                    <a href="manage_doctors.jsp"
                                                        class="btn btn-light btn-sm w-100">Manage
                                                        Doctors</a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card text-white bg-success mb-3 h-100">
                                                <div class="card-header">Patients</div>
                                                <div class="card-body">
                                                    <h1 class="display-4">
                                                        <%= patientCount %>
                                                    </h1>
                                                    <p class="card-text">Total Patient Records</p>
                                                    <a href="manage_patients.jsp"
                                                        class="btn btn-light btn-sm w-100">Manage
                                                        Patients</a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card text-white bg-warning mb-3 h-100">
                                                <div class="card-header text-dark">Pending Appointments</div>
                                                <div class="card-body text-dark">
                                                    <h1 class="display-4">
                                                        <%= pendingCount %>
                                                    </h1>
                                                    <p class="card-text">Scheduled Visits</p>
                                                    <a href="assign_appointment.jsp"
                                                        class="btn btn-light btn-sm w-100">View
                                                        Schedule</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                            </div>
                    </div>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>