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
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Doctor Dashboard | CareConnect</title>
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
                                            <h2 class="mb-1">Medical Dashboard</h2>
                                            <p class="text-secondary small mb-0">Manage your patient schedule and
                                                medical records</p>
                                        </div>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="text-end">
                                                <div class="fw-semibold text-dark">Dr. <%= user.getFullName() %>
                                                </div>
                                                <div class="text-secondary small">
                                                    <%= user.getSpecialization() %>
                                                </div>
                                            </div>
                                        </div>
                                    </header>

                                    <div class="row g-4 animate-fade" style="animation-delay: 0.1s;">
                                        <div class="col-lg-12">
                                            <div class="card border-0 shadow-sm"
                                                style="border-radius: var(--radius-xl);">
                                                <div
                                                    class="card-header bg-white py-4 border-0 d-flex justify-content-between align-items-center">
                                                    <h5 class="mb-0 fw-semibold">Upcoming Appointments</h5>
                                                    <span class="badge bg-primary-subtle text-primary px-3 py-2">
                                                        <%= appointments.size() %> SCHEDULED
                                                    </span>
                                                </div>
                                                <div class="card-body p-0">
                                                    <% if (appointments.isEmpty()) { %>
                                                        <div class="text-center py-5">
                                                            <div class="mb-3 text-muted opacity-25">
                                                                <i data-lucide="calendar-x"
                                                                    style="width: 64px; height: 64px;"></i>
                                                            </div>
                                                            <h6 class="text-secondary">No appointments scheduled for
                                                                today</h6>
                                                            <p class="small text-muted">You're all caught up!</p>
                                                        </div>
                                                        <% } else { %>
                                                            <div class="table-responsive">
                                                                <table class="table table-hover align-middle mb-0">
                                                                    <thead class="bg-light">
                                                                        <tr>
                                                                            <th
                                                                                class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                TIME & DATE</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                PATIENT NAME</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                ADMIN NOTES</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                STATUS</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                ACTION</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% for(Appointment appt : appointments) { %>
                                                                            <tr>
                                                                                <td class="ps-4">
                                                                                    <div
                                                                                        class="d-flex align-items-center gap-2">
                                                                                        <i data-lucide="clock"
                                                                                            class="text-primary"
                                                                                            style="width: 16px; height: 16px;"></i>
                                                                                        <span class="fw-medium">
                                                                                            <%= appt.getAppointmentTime()
                                                                                                %>
                                                                                        </span>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <div class="fw-semibold text-dark">
                                                                                        <%= appt.getPatientName() %>
                                                                                    </div>
                                                                                </td>
                                                                                <td class="text-secondary small">
                                                                                    <% if (appt.getAdminNotes() !=null
                                                                                        &&
                                                                                        !appt.getAdminNotes().isEmpty())
                                                                                        { %>
                                                                                        <%= appt.getAdminNotes() %>
                                                                                            <% } else { %>
                                                                                                <span
                                                                                                    class="text-muted italic">No
                                                                                                    notes
                                                                                                    provided</span>
                                                                                                <% } %>
                                                                                </td>
                                                                                <td>
                                                                                    <span
                                                                                        class="badge bg-warning-subtle text-warning-emphasis px-2 py-1">
                                                                                        <%= appt.getStatus() %>
                                                                                    </span>
                                                                                </td>
                                                                                <td class="text-end pe-4">
                                                                                    <button
                                                                                        class="btn btn-sm btn-primary px-3">Begin
                                                                                        Session</button>
                                                                                </td>
                                                                            </tr>
                                                                            <% } %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                            <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </main>
                        </div>
                        <script>
                            lucide.createIcons();
                        </script>
                    </body>

                    </html>