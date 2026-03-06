<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<PatientReport> reports;
                    if ("DOCTOR".equals(user.getRole())) {
                    reports = hospitalDAO.getAllReports(); // For simplicity, doctors see all for now
                    } else {
                    reports = hospitalDAO.getAllReports(); // Admins see all
                    }
                    List<Patient> patients = hospitalDAO.getAllPatients();
                        List<BillingCatalog> tests = hospitalDAO.getBillingCatalog(); // Assuming categories include 'Test' or 'Lab'
                        %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Diagnostic Reports | CareConnect</title>
                                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                    rel="stylesheet">
                                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                                <script src="https://unpkg.com/lucide@latest"></script>
                            </head>

                            <body>
                                <div class="d-flex">
                                    <% if ("ADMIN".equals(user.getRole())) { %>
                                        <%@ include file="admin/sidebar.jsp" %>
                                            <% } else { %>
                                                <%@ include file="doctor/sidebar.jsp" %>
                                                    <% } %>
                                                        <main class="main-content flex-grow-1">
                                                            <header
                                                                class="d-flex justify-content-between align-items-center mb-5 animate-fade">
                                                                <div>
                                                                    <h2 class="mb-1">Diagnostic & Lab Reports</h2>
                                                                </div>
                                                            </header>

                                                            <% if (request.getParameter("success") !=null) { %>
                                                                <div
                                                                    class="alert alert-success border-0 shadow-sm mb-4 animate-fade">
                                                                    <i data-lucide="check-circle" class="me-2"
                                                                        style="width: 18px; height: 18px;"></i>
                                                                    <%= request.getParameter("success") %>
                                                                </div>
                                                                <% } %>

                                                                    <div class="row g-4 animate-fade">
                                                                        <div class="col-lg-8">
                                                                            <div class="card border-0 shadow-sm"
                                                                                style="border-radius: var(--radius-xl);">
                                                                                <div
                                                                                    class="card-header bg-white py-3 border-0">
                                                                                    <h5 class="mb-0 fw-semibold">Report
                                                                                        Registry</h5>
                                                                                </div>
                                                                                <div class="card-body p-0">
                                                                                    <div class="table-responsive">
                                                                                        <table
                                                                                            class="table table-hover align-middle mb-0">
                                                                                            <thead class="bg-light">
                                                                                                <tr>
                                                                                                    <th
                                                                                                        class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                                        PATIENT & TEST
                                                                                                    </th>
                                                                                                    <th
                                                                                                        class="py-3 text-secondary small fw-semibold">
                                                                                                        DATE</th>
                                                                                                    <th
                                                                                                        class="py-3 text-secondary small fw-semibold">
                                                                                                        FINDINGS</th>
                                                                                                    <th
                                                                                                        class="py-3 text-secondary small fw-semibold">
                                                                                                        STATUS</th>
                                                                                                    <th
                                                                                                        class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                                        ACTION</th>
                                                                                                </tr>
                                                                                            </thead>
                                                                                            <tbody>
                                                                                                <% for(PatientReport r :
                                                                                                    reports) { %>
                                                                                                    <tr>
                                                                                                        <td
                                                                                                            class="ps-4">
                                                                                                            <div
                                                                                                                class="fw-medium text-dark">
                                                                                                                <%= r.getPatientName()
                                                                                                                    %>
                                                                                                            </div>
                                                                                                            <div
                                                                                                                class="text-secondary small">
                                                                                                                <%= r.getTestName()
                                                                                                                    %>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td
                                                                                                            class="small">
                                                                                                            <%= r.getTestDate()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <div class="text-truncate"
                                                                                                                style="max-width: 200px;">
                                                                                                                <%= r.getFindings()
                                                                                                                    %>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <% if("Completed".equals(r.getStatus()))
                                                                                                                { %>
                                                                                                                <span
                                                                                                                    class="badge bg-success-subtle text-success border-0">Completed</span>
                                                                                                                <% } else
                                                                                                                    { %>
                                                                                                                    <span
                                                                                                                        class="badge bg-warning-subtle text-warning border-0">Pending</span>
                                                                                                                    <% }
                                                                                                                        %>
                                                                                                        </td>
                                                                                                        <td
                                                                                                            class="text-end pe-4">
                                                                                                            <button
                                                                                                                class="btn btn-sm btn-outline-secondary border-0">
                                                                                                                <i data-lucide="eye"
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
                                                                                <div
                                                                                    class="card-header bg-white py-3 border-0">
                                                                                    <h5 class="mb-0 fw-semibold">New
                                                                                        Entry</h5>
                                                                                </div>
                                                                                <div class="card-body">
                                                                                    <form
                                                                                        action="${pageContext.request.contextPath}/admin/addReport"
                                                                                        method="POST">
                                                                                        <div class="mb-3">
                                                                                            <label
                                                                                                class="form-label small fw-medium text-secondary">Patient</label>
                                                                                            <select name="patientId"
                                                                                                class="form-select"
                                                                                                required>
                                                                                                <% for(Patient p :
                                                                                                    patients) { %>
                                                                                                    <option
                                                                                                        value="<%= p.getId() %>">
                                                                                                        <%= p.getFullName()
                                                                                                            %>
                                                                                                    </option>
                                                                                                    <% } %>
                                                                                            </select>
                                                                                        </div>
                                                                                        <div class="mb-3">
                                                                                            <label
                                                                                                class="form-label small fw-medium text-secondary">Diagnostic
                                                                                                Test</label>
                                                                                            <select name="testId"
                                                                                                class="form-select"
                                                                                                required>
                                                                                                <% for(BillingCatalog t
                                                                                                    : tests) { %>
                                                                                                    <option
                                                                                                        value="<%= t.getId() %>">
                                                                                                        <%= t.getItemName()
                                                                                                            %> (₹<%=
                                                                                                                t.getPrice()
                                                                                                                %>)
                                                                                                    </option>
                                                                                                    <% } %>
                                                                                            </select>
                                                                                        </div>
                                                                                        <div class="mb-3">
                                                                                            <label
                                                                                                class="form-label small fw-medium text-secondary">Linked
                                                                                                Admission
                                                                                                (Optional)</label>
                                                                                            <input type="number"
                                                                                                name="admissionId"
                                                                                                class="form-control"
                                                                                                placeholder="ID">
                                                                                        </div>
                                                                                        <div class="mb-3">
                                                                                            <label
                                                                                                class="form-label small fw-medium text-secondary">Findings
                                                                                                / Observations</label>
                                                                                            <textarea name="findings"
                                                                                                class="form-control"
                                                                                                rows="4" required
                                                                                                placeholder="Enter clinical results..."></textarea>
                                                                                        </div>
                                                                                        <div class="mb-4">
                                                                                            <label
                                                                                                class="form-label small fw-medium text-secondary">Status</label>
                                                                                            <select name="status"
                                                                                                class="form-select">
                                                                                                <option
                                                                                                    value="Completed">
                                                                                                    Completed</option>
                                                                                                <option value="Pending">
                                                                                                    Pending</option>
                                                                                            </select>
                                                                                        </div>
                                                                                        <button type="submit"
                                                                                            class="btn btn-primary w-100 py-2">
                                                                                            <i data-lucide="file-plus"
                                                                                                class="me-1"
                                                                                                style="width: 18px; height: 18px;"></i>
                                                                                            Record Findings
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