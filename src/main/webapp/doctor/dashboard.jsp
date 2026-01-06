<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"DOCTOR".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<Appointment> appointments =
                    hospitalDAO.getAppointmentsByDoctor(user.getId());
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <title>Doctor Dashboard</title>
                        <!-- Bootstrap 5 CSS -->
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <style>
                            .sidebar {
                                height: 100vh;
                                width: 250px;
                                position: fixed;
                                top: 0;
                                left: 0;
                                background-color: #212529;
                                padding-top: 20px;
                            }

                            .sidebar a {
                                padding: 10px 15px;
                                text-decoration: none;
                                font-size: 18px;
                                color: #f1f1f1;
                                display: block;
                            }

                            .sidebar a:hover {
                                color: #0d6efd;
                            }

                            .content {
                                margin-left: 250px;
                                padding: 20px;
                            }
                        </style>
                    </head>

                    <body>

                        <!-- Doctor Sidebar -->
                        <div class="sidebar">
                            <h4 class="text-white text-center">CareConnect</h4>
                            <hr class="text-white">
                            <a href="#">Dashboard</a>
                            <a href="#">My Schedule</a>
                            <hr class="text-white">
                            <a href="${pageContext.request.contextPath}/auth/logout" class="text-danger">Logout</a>
                        </div>

                        <!-- Main Content -->
                        <div class="content">
                            <h2>Welcome, Dr. <%= user.getFullName() %>
                            </h2>
                            <p class="text-muted">Here are your upcoming appointments.</p>

                            <div class="card mt-4">
                                <div class="card-header bg-primary text-white">
                                    Assigned Appointments
                                </div>
                                <div class="card-body">
                                    <% if (appointments.isEmpty()) { %>
                                        <p class="text-center">No appointments scheduled yet.</p>
                                        <% } else { %>
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Date & Time</th>
                                                        <th>Patient Name</th>
                                                        <th>Admin Notes</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% for(Appointment appt : appointments) { %>
                                                        <tr>
                                                            <td>
                                                                <%= appt.getAppointmentTime() %>
                                                            </td>
                                                            <td>
                                                                <%= appt.getPatientName() %>
                                                            </td>
                                                            <td>
                                                                <%= appt.getAdminNotes() !=null ? appt.getAdminNotes()
                                                                    : "-" %>
                                                            </td>
                                                            <td>
                                                                <span class="badge bg-warning text-dark">
                                                                    <%= appt.getStatus() %>
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-sm btn-success">Complete</button>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                                </tbody>
                                            </table>
                                            <% } %>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>