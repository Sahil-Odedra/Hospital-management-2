<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<User> doctors = hospitalDAO.getAllDoctors();
                    List<Patient> patients = hospitalDAO.getAllPatients();
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Schedule Appointment | CareConnect</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                            <script src="https://unpkg.com/lucide@latest"></script>
                        </head>

                        <body>
                            <div class="d-flex">
                                <%@ include file="sidebar.jsp" %>

                                    <main class="main-content flex-grow-1">
                                        <header
                                            class="d-flex justify-content-between align-items-center mb-5 animate-fade">
                                            <div>
                                                <h2 class="mb-1">Assign Appointment</h2>
                                            </div>
                                        </header>

                                        <% if (request.getParameter("success") !=null) { %>
                                            <div class="alert alert-success border-0 shadow-sm mb-4 animate-fade">
                                                <i data-lucide="check-circle" class="me-2"
                                                    style="width: 18px; height: 18px;"></i>
                                                <%= request.getParameter("success") %>
                                            </div>
                                            <% } %>

                                                <div class="row animate-fade" style="animation-delay: 0.1s;">
                                                    <div class="col-lg-6">
                                                        <div class="card border-0 shadow-sm"
                                                            style="border-radius: var(--radius-xl);">
                                                            <div class="card-header bg-white py-3 border-0">
                                                                <h5 class="mb-0 fw-semibold">Appointment Details</h5>
                                                            </div>
                                                            <div class="card-body">
                                                                <form
                                                                    action="${pageContext.request.contextPath}/admin/assignAppointment"
                                                                    method="POST">
                                                                    <div class="mb-4">
                                                                        <label
                                                                            class="form-label small fw-medium text-secondary">Patient
                                                                            Selection</label>
                                                                        <div class="input-group">
                                                                            <span
                                                                                class="input-group-text bg-white border-end-0 py-2"><i
                                                                                    data-lucide="user"
                                                                                    style="width: 18px; height: 18px; color: #94a3b8;"></i></span>
                                                                            <select name="patientId"
                                                                                class="form-select border-start-0 ps-0"
                                                                                required>
                                                                                <option value="">Choose Patient...
                                                                                </option>
                                                                                <% for(Patient p : patients) { %>
                                                                                    <option value="<%= p.getId() %>">
                                                                                        <%= p.getFullName() %> (<%=
                                                                                                p.getEmail() %>)
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <div class="mb-4">
                                                                        <label
                                                                            class="form-label small fw-medium text-secondary">Assign
                                                                            Medical Staff</label>
                                                                        <div class="input-group">
                                                                            <span
                                                                                class="input-group-text bg-white border-end-0 py-2"><i
                                                                                    data-lucide="stethoscope"
                                                                                    style="width: 18px; height: 18px; color: #94a3b8;"></i></span>
                                                                            <select name="doctorId"
                                                                                class="form-select border-start-0 ps-0"
                                                                                required>
                                                                                <option value="">Select Practitioner...
                                                                                </option>
                                                                                <% for(User d : doctors) { %>
                                                                                    <option value="<%= d.getId() %>">Dr.
                                                                                        <%= d.getFullName() %> - <%=
                                                                                                d.getSpecialization() %>
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <div class="row g-3">
                                                                        <div class="col-md-6 mb-4">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Preferred
                                                                                Date</label>
                                                                            <div class="input-group">
                                                                                <span
                                                                                    class="input-group-text bg-white border-end-0 py-2"><i
                                                                                        data-lucide="calendar"
                                                                                        style="width: 18px; height: 18px; color: #94a3b8;"></i></span>
                                                                                <input type="date"
                                                                                    name="appointmentDate"
                                                                                    class="form-control border-start-0 ps-0"
                                                                                    min="<%= java.time.LocalDate.now() %>"
                                                                                    required>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-md-6 mb-4">
                                                                            <label
                                                                                class="form-label small fw-medium text-secondary">Time
                                                                                Slot</label>
                                                                            <div class="input-group">
                                                                                <span
                                                                                    class="input-group-text bg-white border-end-0 py-2"><i
                                                                                        data-lucide="clock"
                                                                                        style="width: 18px; height: 18px; color: #94a3b8;"></i></span>
                                                                                <select name="appointmentTime"
                                                                                    class="form-select border-start-0 ps-0"
                                                                                    required>
                                                                                    <option value="09:00:00">09:00 AM
                                                                                    </option>
                                                                                    <option value="10:00:00">10:00 AM
                                                                                    </option>
                                                                                    <option value="11:00:00">11:00 AM
                                                                                    </option>
                                                                                    <option value="12:00:00">12:00 PM
                                                                                    </option>
                                                                                    <option value="14:00:00">02:00 PM
                                                                                    </option>
                                                                                    <option value="15:00:00">03:00 PM
                                                                                    </option>
                                                                                    <option value="16:00:00">04:00 PM
                                                                                    </option>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <div class="mb-4">
                                                                        <label
                                                                            class="form-label small fw-medium text-secondary">Administrative
                                                                            Notes</label>
                                                                        <textarea name="adminNotes" class="form-control"
                                                                            rows="3"
                                                                            placeholder="Symptoms, purpose of visit, or allergies..."></textarea>
                                                                    </div>

                                                                    <button type="submit"
                                                                        class="btn btn-primary w-100 py-3 mt-2 shadow-sm">
                                                                        <i data-lucide="calendar-check" class="me-2"
                                                                            style="width: 20px; height: 20px;"></i>
                                                                        Confirm Appointment
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-lg-5 offset-lg-1 d-none d-lg-block">
                                                        <div class="card border-0 shadow-sm animate-fade"
                                                            style="border-radius: var(--radius-xl); animation-delay: 0.3s;">
                                                            <div
                                                                class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                                                                <h5 class="mb-0 fw-semibold">Appointment Calendar</h5>
                                                                <span class="badge bg-primary-subtle text-primary">
                                                                    <%= java.time.LocalDate.now().getMonth() %>
                                                                        <%= java.time.Year.now() %>
                                                                </span>
                                                            </div>
                                                            <div class="card-body p-4">
                                                                <% java.time.LocalDate today=java.time.LocalDate.now();
                                                                    java.time.YearMonth
                                                                    yearMonth=java.time.YearMonth.from(today);
                                                                    java.time.LocalDate firstOfMonth=yearMonth.atDay(1);
                                                                    int daysInMonth=yearMonth.lengthOfMonth(); int
                                                                    dayOfWeek=firstOfMonth.getDayOfWeek().getValue() %
                                                                    7; // 0=Sun, 6=Sat java.util.Map<String, Integer>
                                                                    counts = hospitalDAO.getAppointmentCountsByDate();
                                                                    %>

                                                                    <!-- Calendar Grid -->
                                                                    <div class="d-grid"
                                                                        style="grid-template-columns: repeat(7, 1fr); gap: 8px; text-align: center;">
                                                                        <!-- Headers -->
                                                                        <div class="small fw-bold text-secondary">Sun
                                                                        </div>
                                                                        <div class="small fw-bold text-secondary">Mon
                                                                        </div>
                                                                        <div class="small fw-bold text-secondary">Tue
                                                                        </div>
                                                                        <div class="small fw-bold text-secondary">Wed
                                                                        </div>
                                                                        <div class="small fw-bold text-secondary">Thu
                                                                        </div>
                                                                        <div class="small fw-bold text-secondary">Fri
                                                                        </div>
                                                                        <div class="small fw-bold text-secondary">Sat
                                                                        </div>

                                                                        <!-- Empty cells -->
                                                                        <% for(int i=0; i<dayOfWeek; i++) { %>
                                                                            <div class="p-2"></div>
                                                                            <% } %>

                                                                                <!-- Days -->
                                                                                <% for(int d=1; d<=daysInMonth; d++) {
                                                                                    String
                                                                                    dateStr=String.format("%d-%02d-%02d",
                                                                                    today.getYear(),
                                                                                    today.getMonthValue(), d); int
                                                                                    count=counts.getOrDefault(dateStr,
                                                                                    0); boolean
                                                                                    isToday=(d==today.getDayOfMonth());
                                                                                    %>
                                                                                    <div class="p-2 rounded-3 position-relative border <%= isToday ? "
                                                                                        bg-primary-subtle
                                                                                        border-primary"
                                                                                        : "bg-light border-0" %>">
                                                                                        <span
                                                                                            class="small fw-medium <%= isToday ? "
                                                                                            text-primary" : "text-dark"
                                                                                            %>"><%= d %></span>
                                                                                        <% if(count> 0) { %>
                                                                                            <div class="mt-1">
                                                                                                <span
                                                                                                    class="badge rounded-pill bg-primary"
                                                                                                    style="font-size: 0.65rem;">
                                                                                                    <%= count %>
                                                                                                </span>
                                                                                            </div>
                                                                                            <% } else { %>
                                                                                                <div class="mt-1"
                                                                                                    style="height: 18px;">
                                                                                                </div>
                                                                                                <% } %>
                                                                                    </div>
                                                                                    <% } %>
                                                                    </div>

                                                                    <div class="mt-4 pt-3 border-top">
                                                                        <div
                                                                            class="d-flex align-items-center gap-2 small text-secondary">
                                                                            <i data-lucide="info"
                                                                                style="width: 14px; height: 14px;"></i>
                                                                            <span>Numbers indicate appointments
                                                                                scheduled.</span>
                                                                        </div>
                                                                    </div>
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
                            </script>
                        </body>

                        </html>