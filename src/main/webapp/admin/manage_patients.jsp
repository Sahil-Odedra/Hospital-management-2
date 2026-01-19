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
                        <title>Manage Patients</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                    </head>

                    <body>
                        <div class="d-flex">
                            <%@ include file="sidebar.jsp" %>

                                <div class="flex-grow-1 p-4" style="margin-left: 280px;">
                                    <h3>Manage Patients</h3>

                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success">
                                            <%= request.getParameter("success") %>
                                        </div>
                                        <% } %>
                                            <% if (request.getParameter("error") !=null) { %>
                                                <div class="alert alert-danger">
                                                    <%= request.getParameter("error") %>
                                                </div>
                                                <% } %>

                                                    <div class="row mt-4">
                                                        <!-- List Patients -->
                                                        <div class="col-md-7">
                                                            <div class="card">
                                                                <div class="card-header">Patient Records</div>
                                                                <div class="card-body">
                                                                    <table class="table table-hover">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Name</th>
                                                                                <th>Email</th>
                                                                                <th>Phone</th>
                                                                                <th>DOB</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <% for(Patient p : patients) { %>
                                                                                <tr>
                                                                                    <td>
                                                                                        <%= p.getFullName() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= p.getEmail() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= p.getPhone() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= p.getDob() %>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } %>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Add Patient Form -->
                                                        <div class="col-md-5">
                                                            <div class="card">
                                                                <div class="card-header">Register New Patient</div>
                                                                <div class="card-body">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/admin/addPatient"
                                                                        method="POST">
                                                                        <div class="mb-3">
                                                                            <label>Full Name</label>
                                                                            <input type="text" name="fullName"
                                                                                class="form-control" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label>Email (For Notifications)</label>
                                                                            <input type="email" name="email"
                                                                                class="form-control" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label>Phone Number</label>
                                                                            <input type="text" name="phone"
                                                                                class="form-control" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label>Date of Birth</label>
                                                                            <input type="date" name="dob"
                                                                                class="form-control"
                                                                                max="<%= java.time.LocalDate.now() %>"
                                                                                required>
                                                                        </div>
                                                                        <button type="submit"
                                                                            class="btn btn-primary w-100">Register
                                                                            Patient</button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                </div>
                        </div>
                    </body>

                    </html>