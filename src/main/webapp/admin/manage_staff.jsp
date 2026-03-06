<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<Staff> staffList = hospitalDAO.getAllStaff();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Staff Registry | CareConnect</title>
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
                                            <h2 class="mb-1">Staff Registry</h2>
                                        </div>
                                    </header>

                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success border-0 shadow-sm mb-4 animate-fade">
                                            <i data-lucide="check-circle" class="me-2"
                                                style="width: 18px; height: 18px;"></i>
                                            <%= request.getParameter("success") %>
                                        </div>
                                        <% } %>

                                            <div class="row g-4 animate-fade">
                                                <div class="col-lg-8">
                                                    <div class="card border-0 shadow-sm"
                                                        style="border-radius: var(--radius-xl);">
                                                        <div class="card-header bg-white py-3 border-0">
                                                            <h5 class="mb-0 fw-semibold">Personnel Database</h5>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover align-middle mb-0">
                                                                    <thead class="bg-light">
                                                                        <tr>
                                                                            <th
                                                                                class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                NAME & ROLE</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                CONTACT</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                ASSIGNMENT</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                ACTION</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% for(Staff s : staffList) { %>
                                                                            <tr>
                                                                                <td class="ps-4">
                                                                                    <div class="fw-medium text-dark">
                                                                                        <%= s.getName() %>
                                                                                    </div>
                                                                                    <div class="text-secondary small">
                                                                                        <%= s.getRole() %>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <%= s.getPhone() %>
                                                                                </td>
                                                                                <td>
                                                                                    <span
                                                                                        class="badge bg-secondary-subtle text-secondary border-0">
                                                                                        <%= s.getAssignedToType() %>
                                                                                    </span>
                                                                                    <span
                                                                                        class="ms-1 text-secondary small">ID:
                                                                                        <%= s.getAssignedToId() %>
                                                                                            </span>
                                                                                </td>
                                                                                <td class="text-end pe-4">
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-danger border-0">
                                                                                        <i data-lucide="user-minus"
                                                                                            style="width: 16px; height: 16px;"></i>
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

                                                <div class="col-lg-4">
                                                    <div class="card border-0 shadow-sm"
                                                        style="border-radius: var(--radius-xl);">
                                                        <div class="card-header bg-white py-3 border-0">
                                                            <h5 class="mb-0 fw-semibold">Recruit Personnel</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/addStaff"
                                                                method="POST">
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Full
                                                                        Name</label>
                                                                    <input type="text" name="name" class="form-control"
                                                                        required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Role</label>
                                                                    <select name="role" class="form-select" required>
                                                                        <option value="Nurse">Nurse</option>
                                                                        <option value="Ward Boy">Ward Boy</option>
                                                                        <option value="Janitor">Janitor</option>
                                                                        <option value="Receptionist">Receptionist
                                                                        </option>
                                                                        <option value="Pharmacist">Pharmacist</option>
                                                                        <option value="Security">Security</option>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Phone
                                                                        Number</label>
                                                                    <input type="text" name="phone" class="form-control"
                                                                        required>
                                                                </div>
                                                                <div class="row g-2 mb-3">
                                                                    <div class="col-md-6">
                                                                        <label
                                                                            class="form-label small fw-medium text-secondary">Assign
                                                                            To</label>
                                                                        <select name="assignedToType"
                                                                            class="form-select" required>
                                                                            <option value="WARD">Ward/Floor</option>
                                                                            <option value="DEPT">Department</option>
                                                                            <option value="GEN">General</option>
                                                                        </select>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label
                                                                            class="form-label small fw-medium text-secondary">Assign
                                                                            ID</label>
                                                                        <input type="number" name="assignedToId"
                                                                            class="form-control" value="0">
                                                                    </div>
                                                                </div>
                                                                <button type="submit"
                                                                    class="btn btn-primary w-100 py-2 mt-2">
                                                                    <i data-lucide="user-plus" class="me-1"
                                                                        style="width: 18px; height: 18px;"></i>
                                                                    Register Staff
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                </main>
                        </div>
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>lucide.createIcons();</script>
                    </body>

                    </html>