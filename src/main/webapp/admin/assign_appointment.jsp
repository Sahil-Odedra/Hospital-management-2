<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List, java.util.Map" %>
        <%@ page import="java.time.*" %>
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

                                                <% if (request.getParameter("error") !=null) { %>
                                                    <div
                                                        class="alert alert-danger border-0 shadow-sm mb-4 animate-fade">
                                                        <i data-lucide="alert-circle" class="me-2"
                                                            style="width: 18px; height: 18px;"></i>
                                                        <%= request.getParameter("error") %>
                                                    </div>
                                                    <% } %>

                                                        <div class="row animate-fade" style="animation-delay: 0.1s;">
                                                            <div class="col-lg-6">
                                                                <div class="card border-0 shadow-sm"
                                                                    style="border-radius: var(--radius-xl);">
                                                                    <div class="card-header bg-white py-3 border-0">
                                                                        <h5 class="mb-0 fw-semibold">Appointment Details
                                                                        </h5>
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
                                                                                        class="input-group-text bg-white border-end-0 py-2">
                                                                                        <i data-lucide="user"
                                                                                            style="width: 18px; height: 18px; color: #94a3b8;"></i>
                                                                                    </span>
                                                                                    <select name="patientId"
                                                                                        class="form-select border-start-0 ps-0"
                                                                                        required>
                                                                                        <option value="">Choose
                                                                                            Patient...
                                                                                        </option>
                                                                                        <% for(Patient p : patients) {
                                                                                            %>
                                                                                            <option
                                                                                                value="<%= p.getId() %>">
                                                                                                <%= p.getFullName() %> (
                                                                                                    <%= p.getEmail() %>)
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
                                                                                        class="input-group-text bg-white border-end-0 py-2">
                                                                                        <i data-lucide="stethoscope"
                                                                                            style="width: 18px; height: 18px; color: #94a3b8;"></i>
                                                                                    </span>
                                                                                    <select name="doctorId"
                                                                                        id="doctorId"
                                                                                        class="form-select border-start-0 ps-0"
                                                                                        required>
                                                                                        <option value="">Select
                                                                                            Practitioner...
                                                                                        </option>
                                                                                        <% for(User d : doctors) { %>
                                                                                            <option
                                                                                                value="<%= d.getId() %>">
                                                                                                <%= d.getFullName() %> -
                                                                                                    <%= d.getSpecialization()
                                                                                                        %>
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
                                                                                            class="input-group-text bg-white border-end-0 py-2">
                                                                                            <i data-lucide="calendar"
                                                                                                style="width: 18px; height: 18px; color: #94a3b8;"></i>
                                                                                        </span>
                                                                                        <input type="date"
                                                                                            name="appointmentDate"
                                                                                            id="appointmentDate"
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
                                                                                            class="input-group-text bg-white border-end-0 py-2">
                                                                                            <i data-lucide="clock"
                                                                                                style="width: 18px; height: 18px; color: #94a3b8;"></i>
                                                                                        </span>
                                                                                        <select name="appointmentTime"
                                                                                            id="appointmentTime"
                                                                                            class="form-select border-start-0 ps-0"
                                                                                            required>
                                                                                            <option value="">Select
                                                                                                Time...
                                                                                            </option>
                                                                                            <% String[]
                                                                                                hours={"09", "10" , "11"
                                                                                                , "12" , "13" , "14"
                                                                                                , "15" , "16" , "17" };
                                                                                                String[]
                                                                                                mins={"00", "30" };
                                                                                                for(String h : hours) {
                                                                                                for(String m : mins) {
                                                                                                String tVal=h + ":" + m
                                                                                                + ":00" ; int
                                                                                                hh=Integer.parseInt(h);
                                                                                                String displayT=(hh> 12
                                                                                                ? (hh-12) : hh)
                                                                                                + ":" + m + (hh >= 12 ?
                                                                                                " PM" :
                                                                                                " AM");
                                                                                                %>
                                                                                                <option
                                                                                                    value="<%= tVal %>">
                                                                                                    <%= displayT %>
                                                                                                </option>
                                                                                                <% } } %>
                                                                                        </select>
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <div class="mb-4">
                                                                                <label
                                                                                    class="form-label small fw-medium text-secondary">Administrative
                                                                                    Notes</label>
                                                                                <textarea name="adminNotes"
                                                                                    class="form-control"
                                                                                    rows="3"></textarea>
                                                                            </div>

                                                                            <button type="submit"
                                                                                class="btn btn-primary w-100 py-3 mt-2 shadow-sm">
                                                                                <i data-lucide="calendar-check"
                                                                                    class="me-2"
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
                                                                        <h5 class="mb-0 fw-semibold">Appointment
                                                                            Calendar</h5>
                                                                        <span
                                                                            class="badge bg-primary-subtle text-primary">
                                                                            <%= java.time.LocalDate.now().getMonth() %>
                                                                                <%= java.time.Year.now() %>
                                                                        </span>
                                                                    </div>
                                                                    <div class="card-body p-4">
                                                                        <% java.time.LocalDate
                                                                            today=java.time.LocalDate.now();
                                                                            java.time.YearMonth
                                                                            yearMonth=java.time.YearMonth.from(today);
                                                                            java.time.LocalDate
                                                                            firstOfMonth=yearMonth.atDay(1); int
                                                                            daysInMonth=yearMonth.lengthOfMonth(); int
                                                                            dayOfWeekInitial=firstOfMonth.getDayOfWeek().getValue()
                                                                            % 7; java.util.Map<String, Integer>
                                                                            countsVal =
                                                                            hospitalDAO.getAppointmentCountsByDate();
                                                                            %>

                                                                            <div class="d-grid"
                                                                                style="grid-template-columns: repeat(7, 1fr); gap: 8px; text-align: center;">
                                                                                <div
                                                                                    class="small fw-bold text-secondary">
                                                                                    Sun
                                                                                </div>
                                                                                <div
                                                                                    class="small fw-bold text-secondary">
                                                                                    Mon
                                                                                </div>
                                                                                <div
                                                                                    class="small fw-bold text-secondary">
                                                                                    Tue
                                                                                </div>
                                                                                <div
                                                                                    class="small fw-bold text-secondary">
                                                                                    Wed
                                                                                </div>
                                                                                <div
                                                                                    class="small fw-bold text-secondary">
                                                                                    Thu
                                                                                </div>
                                                                                <div
                                                                                    class="small fw-bold text-secondary">
                                                                                    Fri
                                                                                </div>
                                                                                <div
                                                                                    class="small fw-bold text-secondary">
                                                                                    Sat
                                                                                </div>

                                                                                <% for(int i=0; i<dayOfWeekInitial; i++)
                                                                                    { %>
                                                                                    <div class="p-2"></div>
                                                                                    <% } %>

                                                                                        <% for(int d=1; d<=daysInMonth;
                                                                                            d++) { String
                                                                                            dateKey=String.format("%d-%02d-%02d",
                                                                                            today.getYear(),
                                                                                            today.getMonthValue(), d);
                                                                                            int
                                                                                            cVal=countsVal.getOrDefault(dateKey,
                                                                                            0); boolean
                                                                                            isTodayDay=(d==today.getDayOfMonth());
                                                                                            String cClass=isTodayDay
                                                                                            ? "bg-primary-subtle border-primary"
                                                                                            : "bg-light border-0" ;
                                                                                            String tClass=isTodayDay
                                                                                            ? "text-primary"
                                                                                            : "text-dark" ; %>
                                                                                            <div
                                                                                                class="p-2 rounded-3 position-relative border <%= cClass %>">
                                                                                                <span
                                                                                                    class="small fw-medium <%= tClass %>">
                                                                                                    <%= d %>
                                                                                                </span>
                                                                                                <% if(cVal> 0) { %>
                                                                                                    <div class="mt-1">
                                                                                                        <span
                                                                                                            class="badge rounded-pill bg-primary"
                                                                                                            style="font-size: 0.65rem;">
                                                                                                            <%= cVal %>
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

                                const doctorSelect = document.getElementById('doctorId');
                                const dateInput = document.getElementById('appointmentDate');
                                const timeSelect = document.getElementById('appointmentTime');

                                async function updateAvailableSlots() {
                                    const doctorId = doctorSelect.value;
                                    const date = dateInput.value;

                                    if (!doctorId || !date) {
                                        Array.from(timeSelect.options).forEach(option => {
                                            option.disabled = false;
                                            option.style.backgroundColor = "";
                                            option.text = option.text.split(' (Booked)')[0];
                                        });
                                        return;
                                    }

                                    try {
                                        const response = await fetch(`getBookedSlots?doctorId=${doctorId}&date=${date}`);
                                        const bookedSlotsText = await response.text();
                                        const bookedSlots = bookedSlotsText ? bookedSlotsText.split(',') : [];

                                        Array.from(timeSelect.options).forEach(option => {
                                            if (option.value === "") return;

                                            if (bookedSlots.includes(option.value)) {
                                                option.disabled = true;
                                                option.style.backgroundColor = "#fee2e2";
                                                if (!option.text.includes('(Booked)')) {
                                                    option.text = option.text + " (Booked)";
                                                }
                                            } else {
                                                option.disabled = false;
                                                option.style.backgroundColor = "";
                                                option.text = option.text.replace(" (Booked)", "");
                                            }
                                        });
                                    } catch (error) {
                                        console.error('Error fetching booked slots:', error);
                                    }
                                }

                                doctorSelect.addEventListener('change', updateAvailableSlots);
                                dateInput.addEventListener('change', updateAvailableSlots);
                            </script>
                        </body>

                        </html>