<%@ page import="com.careconnect.model.User" %>
    <%@ page import="com.careconnect.dao.UserDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } UserDAO userDAO=new
                    UserDAO(); List<User> doctors = userDAO.getAllDoctors();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <title>Manage Doctors</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                    </head>

                    <body>
                        <div class="d-flex">
                            <%@ include file="sidebar.jsp" %>

                                <div class="flex-grow-1 p-4" style="margin-left: 280px;">
                                    <h3>Manage Doctors</h3>

                                    <!-- Message Alert -->
                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success">
                                            <%= request.getParameter("success") %>
                                        </div>
                                        <% } %>

                                            <div class="row mt-4">
                                                <!-- List Doctors -->
                                                <div class="col-md-7">
                                                    <div class="card">
                                                        <div class="card-header">Doctor List</div>
                                                        <div class="card-body">
                                                            <table class="table table-hover">
                                                                <thead>
                                                                    <tr>
                                                                        <th>ID</th>
                                                                        <th>Name</th>
                                                                        <th>Specialization</th>
                                                                        <th>Email</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% for(User doc : doctors) { %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= doc.getId() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= doc.getFullName() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= doc.getSpecialization() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= doc.getEmail() %>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add Doctor Form -->
                                                <div class="col-md-5">
                                                    <div class="card">
                                                        <div class="card-header">Add New Doctor</div>
                                                        <div class="card-body">
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/addDoctor"
                                                                method="POST">
                                                                <div class="mb-3">
                                                                    <label>Full Name</label>
                                                                    <input type="text" name="fullName"
                                                                        class="form-control" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label>Specialization</label>
                                                                    <input type="text" name="specialization"
                                                                        class="form-control"
                                                                        placeholder="e.g. Cardiologist" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label>Email (Login ID)</label>
                                                                    <input type="email" name="email"
                                                                        class="form-control" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label>Password</label>
                                                                    <input type="password" name="password"
                                                                        class="form-control" required>
                                                                </div>
                                                                <button type="submit"
                                                                    class="btn btn-primary w-100">Create Doctor</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                </div>
                        </div>
                    </body>

                    </html>