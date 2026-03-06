<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.text.SimpleDateFormat" %>
                <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                    <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole()))
                        { response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                        hospitalDAO=new HospitalDAO(); List<Appointment> appointments =
                        hospitalDAO.getAllAppointments();
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM-yyyy HH:mm");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Appointment Directory | CareConnect</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                            <script src="https://unpkg.com/lucide@latest"></script>
                        </head>

                        <body>
                            <div class="d-flex">
                                <%@ include file="sidebar.jsp" %>
                                    <main class="main-content flex-grow-1">
                                        <header class="d-flex justify-content-between align-items-center mb-5">
                                            <div>
                                                <h2 class="mb-1">Appointment Management</h2>
                                            </div>
                                        </header>

                                        <% if (request.getParameter("success") !=null) { %>
                                            <div class="alert alert-success border-0 shadow-sm mb-4">
                                                <i data-lucide="check-circle" class="me-2"
                                                    style="width: 18px; height: 18px;"></i>
                                                <%= request.getParameter("success") %>
                                            </div>
                                            <% } %>

                                                <div class="card border-0 shadow-sm" style="border-radius: 1rem;">
                                                    <div class="card-body p-0">
                                                        <div class="table-responsive">
                                                            <table class="table table-hover align-middle mb-0">
                                                                <thead class="bg-light">
                                                                    <tr>
                                                                        <th class="ps-4">PATIENT</th>
                                                                        <th>DOCTOR</th>
                                                                        <th>TIME</th>
                                                                        <th>NOTES</th>
                                                                        <th>STATUS</th>
                                                                        <th class="text-end pe-4">ACTION</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% for(Appointment a : appointments) { %>
                                                                        <tr>
                                                                            <td class="ps-4">
                                                                                <div class="fw-medium">
                                                                                    <%= a.getPatientName() %>
                                                                                </div>
                                                                                <div class="small text-secondary">#PAT-
                                                                                    <%= a.getPatientId() %>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <div class="fw-medium">
                                                                                    <%= a.getDoctorName() %>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <div class="small fw-medium">
                                                                                    <i data-lucide="calendar"
                                                                                        class="me-1"
                                                                                        style="width: 14px; height: 14px;"></i>
                                                                                    <%= sdf.format(a.getAppointmentTime())
                                                                                        %>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <div class="small text-secondary text-truncate"
                                                                                    style="max-width: 150px;">
                                                                                    <%= a.getAdminNotes() !=null ?
                                                                                        a.getAdminNotes() : "-" %>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <% String badgeClass="bg-secondary" ;
                                                                                    if("COMPLETED".equals(a.getStatus()))
                                                                                    badgeClass="bg-success" ; else
                                                                                    if("CANCELLED".equals(a.getStatus()))
                                                                                    badgeClass="bg-danger" ; else
                                                                                    if("SCHEDULED".equals(a.getStatus()))
                                                                                    badgeClass="bg-primary" ; %>
                                                                                    <span class="badge <%= badgeClass %>-subtle text-<%= 
                                                            " bg-success".equals(badgeClass) ? "success" :
                                                                                        ("bg-danger".equals(badgeClass)
                                                                                        ? "danger" :
                                                                                        ("bg-primary".equals(badgeClass)
                                                                                        ? "primary" : "secondary" )) %>
                                                                                        border-0">
                                                                                        <%= a.getStatus() %>
                                                                                    </span>
                                                                            </td>
                                                                            <td class="text-end pe-4">
                                                                                <div class="dropdown">
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-secondary dropdown-toggle"
                                                                                        data-bs-toggle="dropdown">
                                                                                        Update
                                                                                    </button>
                                                                                    <ul
                                                                                        class="dropdown-menu dropdown-menu-end">
                                                                                        <li>
                                                                                            <form
                                                                                                action="${pageContext.request.contextPath}/admin/updateAppointmentStatus"
                                                                                                method="POST">
                                                                                                <input type="hidden"
                                                                                                    name="id"
                                                                                                    value="<%= a.getId() %>">
                                                                                                <input type="hidden"
                                                                                                    name="status"
                                                                                                    value="COMPLETED">
                                                                                                <button type="submit"
                                                                                                    class="dropdown-item text-success">
                                                                                                    <i data-lucide="check"
                                                                                                        class="me-2"
                                                                                                        style="width: 14px; height: 14px;"></i>
                                                                                                    Mark Completed
                                                                                                </button>
                                                                                            </form>
                                                                                        </li>
                                                                                        <li>
                                                                                            <form
                                                                                                action="${pageContext.request.contextPath}/admin/updateAppointmentStatus"
                                                                                                method="POST">
                                                                                                <input type="hidden"
                                                                                                    name="id"
                                                                                                    value="<%= a.getId() %>">
                                                                                                <input type="hidden"
                                                                                                    name="status"
                                                                                                    value="CANCELLED">
                                                                                                <button type="submit"
                                                                                                    class="dropdown-item text-danger">
                                                                                                    <i data-lucide="x"
                                                                                                        class="me-2"
                                                                                                        style="width: 14px; height: 14px;"></i>
                                                                                                    Cancel Appointment
                                                                                                </button>
                                                                                            </form>
                                                                                        </li>
                                                                                        <% if("COMPLETED".equals(a.getStatus()))
                                                                                            { %>
                                                                                            <li>
                                                                                                <hr
                                                                                                    class="dropdown-divider">
                                                                                            </li>
                                                                                            <li>
                                                                                                <a href="${pageContext.request.contextPath}/view_opd_bill.jsp?appointmentId=<%= a.getId() %>"
                                                                                                    class="dropdown-item text-primary">
                                                                                                    <i data-lucide="file-text"
                                                                                                        class="me-2"
                                                                                                        style="width: 14px; height: 14px;"></i>
                                                                                                    View Invoice
                                                                                                </a>
                                                                                            </li>
                                                                                            <% } %>
                                                                                    </ul>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                            <% if(appointments.isEmpty()) { %>
                                                                                <tr>
                                                                                    <td colspan="6"
                                                                                        class="text-center py-5 text-secondary">
                                                                                        <i data-lucide="calendar-x"
                                                                                            class="mb-2"
                                                                                            style="width: 40px; height: 40px;"></i>
                                                                                        <p>No appointments scheduled
                                                                                            yet.</p>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } %>
                                                                </tbody>
                                                            </table>
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