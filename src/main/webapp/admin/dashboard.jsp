<%@ page import="com.careconnect.Entities.*" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>Admin Dashboard</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            </head>

            <body>
                <div class="d-flex">
                    <!-- Sidebar -->
                    <%@ include file="sidebar.jsp" %>

                        <!-- Main Content -->
                        <div class="flex-grow-1 p-4" style="margin-left: 280px;">
                            <h2>Welcome, <%= user.getFullName() %>
                            </h2>
                            <p class="lead">Select an action from the sidebar to manage the hospital.</p>

                            <div class="row mt-4">
                                <div class="col-md-4">
                                    <div class="card text-white bg-primary mb-3">
                                        <div class="card-header">Doctors</div>
                                        <div class="card-body">
                                            <h5 class="card-title">Manage Medical Staff</h5>
                                            <p class="card-text">Add new doctors and view current staff.</p>
                                            <a href="manage_doctors.jsp" class="btn btn-light btn-sm">Go to Doctors</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card text-white bg-success mb-3">
                                        <div class="card-header">Patients</div>
                                        <div class="card-body">
                                            <h5 class="card-title">Patient Records</h5>
                                            <p class="card-text">Add new patients and update profiles.</p>
                                            <a href="manage_patients.jsp" class="btn btn-light btn-sm">Go to
                                                Patients</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card text-white bg-warning mb-3">
                                        <div class="card-header">Appointments</div>
                                        <div class="card-body">
                                            <h5 class="card-title">Scheduling</h5>
                                            <p class="card-text">Assign patients to doctors.</p>
                                            <a href="assign_appointment.jsp" class="btn btn-light btn-sm">Schedule
                                                Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>