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
                                                                                        VITAL STATS</th>
                                                                                    <th
                                                                                        class="py-3 text-secondary small fw-semibold">
                                                                                        CONTACT INFO</th>
                                                                                    <th
                                                                                        class="py-3 text-secondary small fw-semibold">
                                                                                        DATE OF BIRTH</th>
                                                                                    <th
                                                                                        class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                        ACTIONS</th>
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
                                                                                                <span
                                                                                                    class="badge bg-secondary-subtle text-secondary border-0">
                                                                                                    <%= p.getGender() %>
                                                                                                </span>
                                                                                                <span
                                                                                                    class="badge bg-danger-subtle text-danger border-0 ms-1">
                                                                                                    <%= p.getBloodGroup()
                                                                                                        %>
                                                                                                </span>
                                                                                            </div>
                                                                                            <div
                                                                                                class="text-secondary small mt-1">
                                                                                                <%= p.getWeight() %>kg |
                                                                                                    <%= p.getHeight() %>
                                                                                                        cm
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
                                                                                            <a href="${pageContext.request.contextPath}/patient_history.jsp?patientId=<%= p.getId() %>"
                                                                                                class="btn btn-link text-primary p-0 border-0 me-2"
                                                                                                title="Clinical History">
                                                                                                <i data-lucide="history"
                                                                                                    style="width: 18px; height: 18px;"></i>
                                                                                            </a>
                                                                                            <button
                                                                                                onclick="confirmDelete('<%= p.getId() %>')"
                                                                                                class="btn btn-link text-danger p-0 border-0"
                                                                                                title="Delete Patient">
                                                                                                <i data-lucide="trash-2"
                                                                                                    style="width: 18px; height: 18px;"></i>
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
                                                                                class="form-control" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Email
                                                                                Address</label>
                                                                            <input type="email" name="email"
                                                                                class="form-control" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Phone
                                                                                Number</label>
                                                                            <input type="text" name="phone"
                                                                                class="form-control" required>
                                                                        </div>
                                                                        <div class="row g-2 mb-3">
                                                                            <div class="col-md-6">
                                                                                <label
                                                                                    class="form-label small fw-medium text-secondary">Gender</label>
                                                                                <select name="gender"
                                                                                    class="form-select" required>
                                                                                    <option value="" disabled selected>
                                                                                        Select</option>
                                                                                    <option value="Male">Male</option>
                                                                                    <option value="Female">Female
                                                                                    </option>
                                                                                    <option value="Other">Other</option>
                                                                                </select>
                                                                            </div>
                                                                            <div class="col-md-6">
                                                                                <label
                                                                                    class="form-label small fw-medium text-secondary">Blood
                                                                                    Group</label>
                                                                                <select name="bloodGroup"
                                                                                    class="form-select" required>
                                                                                    <option value="" disabled selected>
                                                                                        Select</option>
                                                                                    <option value="A+">A+</option>
                                                                                    <option value="A-">A-</option>
                                                                                    <option value="B+">B+</option>
                                                                                    <option value="B-">B-</option>
                                                                                    <option value="O+">O+</option>
                                                                                    <option value="O-">O-</option>
                                                                                    <option value="AB+">AB+</option>
                                                                                    <option value="AB-">AB-</option>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="row g-2 mb-3">
                                                                            <div class="col-md-6">
                                                                                <label
                                                                                    class="form-label small fw-medium text-secondary">Weight
                                                                                    (kg)</label>
                                                                                <input type="number" step="0.1"
                                                                                    name="weight" class="form-control"
                                                                                    placeholder="e.g. 70.5">
                                                                            </div>
                                                                            <div class="col-md-6">
                                                                                <label
                                                                                    class="form-label small fw-medium text-secondary">Height
                                                                                    (cm)</label>
                                                                                <input type="number" step="0.1"
                                                                                    name="height" class="form-control"
                                                                                    placeholder="e.g. 175">
                                                                            </div>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Full
                                                                                Address</label>
                                                                            <textarea name="address"
                                                                                class="form-control" rows="2"
                                                                                placeholder="Street, City, PIN"></textarea>
                                                                        </div>
                                                                        <div class="row g-2 mb-3">
                                                                            <div class="col-md-6">
                                                                                <label
                                                                                    class="form-label small fw-medium text-secondary">Emergency
                                                                                    Name</label>
                                                                                <input type="text"
                                                                                    name="emergencyContactName"
                                                                                    class="form-control">
                                                                            </div>
                                                                            <div class="col-md-6">
                                                                                <label
                                                                                    class="form-label small fw-medium text-secondary">Emergency
                                                                                    Phone</label>
                                                                                <input type="text"
                                                                                    name="emergencyContactPhone"
                                                                                    class="form-control">
                                                                            </div>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Allergies
                                                                                (if any)</label>
                                                                            <input type="text" name="allergies"
                                                                                class="form-control"
                                                                                placeholder="e.g. Penicillin, Peanuts">
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
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            lucide.createIcons();

                            function confirmDelete(id) {
                                if (confirm("Are you sure you want to delete this patient record? This action cannot be undone.")) {
                                    window.location.href = "${pageContext.request.contextPath}/admin/deletePatient?id=" + id;
                                }
                            }
                        </script>
                    </body>

                    </html>