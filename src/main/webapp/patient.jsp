<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% Patient currentUser=(Patient) session.getAttribute("patientUser"); HospitalDAO dao=new HospitalDAO();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Patient Portal | CareConnect</title>
                        <!-- CSS Dependencies -->
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        <script src="https://unpkg.com/lucide@latest"></script>
                        <style>
                            .chat-widget {
                                position: fixed;
                                bottom: 20px;
                                right: 20px;
                                width: 350px;
                                background: #fff;
                                border-radius: 12px;
                                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
                                display: flex;
                                flex-direction: column;
                                overflow: hidden;
                                z-index: 1000;
                            }

                            .chat-header {
                                background: #2563eb;
                                color: #fff;
                                padding: 12px 16px;
                                font-weight: 500;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }

                            .chat-body {
                                height: 300px;
                                overflow-y: auto;
                                padding: 16px;
                                background: #f8fafc;
                                display: flex;
                                flex-direction: column;
                                gap: 12px;
                            }

                            .chat-input-area {
                                display: flex;
                                border-top: 1px solid #e2e8f0;
                                padding: 12px;
                                background: #fff;
                            }

                            .chat-input {
                                flex-grow: 1;
                                border: 1px solid #e2e8f0;
                                border-radius: 20px;
                                padding: 8px 16px;
                                outline: none;
                                font-size: 14px;
                            }

                            .chat-btn {
                                background: #2563eb;
                                color: white;
                                border: none;
                                border-radius: 50%;
                                width: 36px;
                                height: 36px;
                                margin-left: 8px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                            }

                            .msg {
                                max-width: 85%;
                                padding: 10px 14px;
                                border-radius: 12px;
                                font-size: 14px;
                                line-height: 1.4;
                            }

                            .msg-user {
                                background: #2563eb;
                                color: #fff;
                                align-self: flex-end;
                                border-bottom-right-radius: 12px;
                                border-bottom-right-radius: 2px;
                            }

                            .msg-bot {
                                background: #e2e8f0;
                                color: #1e293b;
                                align-self: flex-start;
                                border-bottom-left-radius: 12px;
                                border-bottom-left-radius: 2px;
                            }
                        </style>
                    </head>

                    <body class="bg-light">
                        <!-- Navbar -->
                        <nav class="navbar navbar-expand-lg border-bottom sticky-top glass animate-fade">
                            <div class="container">
                                <a class="navbar-brand d-flex align-items-center gap-2 fw-bold text-primary" href="#">
                                    <i data-lucide="activity"></i> CareConnect Portal
                                </a>
                                <% if (currentUser !=null) { %>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="text-secondary fw-medium">
                                            <%= currentUser.getFullName() %>
                                        </span>
                                        <a href="${pageContext.request.contextPath}/patient/logout"
                                            class="btn btn-outline-danger btn-sm">Logout</a>
                                    </div>
                                    <% } %>
                            </div>
                        </nav>

                        <div class="container py-5 animate-slide-up">
                            <% if (request.getParameter("error") !=null) { %>
                                <div
                                    class="alert alert-danger bg-danger-subtle text-danger-emphasis border-0 alert-dismissible fade show">
                                    <%= request.getParameter("error") %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>
                                    <% if (request.getParameter("success") !=null) { %>
                                        <div
                                            class="alert alert-success bg-success-subtle text-success-emphasis border-0 alert-dismissible fade show">
                                            <%= request.getParameter("success") %>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="alert"></button>
                                        </div>
                                        <% } %>

                                            <% if (currentUser==null) { %>
                                                <!-- Login State -->
                                                <div class="row justify-content-center">
                                                    <div class="col-md-5">
                                                        <div class="card border-0 shadow-sm rounded-4">
                                                            <div class="card-body p-4 p-md-5">
                                                                <div class="text-center mb-4">
                                                                    <div
                                                                        class="bg-primary-subtle text-primary rounded-circle d-inline-flex p-3 mb-3">
                                                                        <i data-lucide="user"
                                                                            style="width: 32px; height: 32px;"></i>
                                                                    </div>
                                                                    <h4>Patient Access Portal</h4>
                                                                    <p class="text-muted small">Enter your details to
                                                                        view your medical records and book appointments.
                                                                    </p>
                                                                </div>
                                                                <form
                                                                    action="${pageContext.request.contextPath}/patient/login"
                                                                    method="POST">
                                                                    <div class="mb-3">
                                                                        <label
                                                                            class="form-label text-secondary small fw-medium">Registered
                                                                            Email</label>
                                                                        <div class="input-group input-group-flat">
                                                                            <span
                                                                                class="input-group-text bg-transparent border-end-0">
                                                                                <i data-lucide="mail" class="text-muted"
                                                                                    style="width: 18px;"></i>
                                                                            </span>
                                                                            <input type="email" name="email"
                                                                                class="form-control border-start-0 ps-0"
                                                                                required placeholder="john@example.com">
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-4">
                                                                        <label
                                                                            class="form-label text-secondary small fw-medium">Date
                                                                            of Birth</label>
                                                                        <div class="input-group input-group-flat">
                                                                            <span
                                                                                class="input-group-text bg-transparent border-end-0">
                                                                                <i data-lucide="calendar"
                                                                                    class="text-muted"
                                                                                    style="width: 18px;"></i>
                                                                            </span>
                                                                            <input type="date" name="dob"
                                                                                class="form-control border-start-0 ps-0"
                                                                                required>
                                                                        </div>
                                                                    </div>
                                                                    <button type="submit"
                                                                        class="btn btn-primary w-100 py-2 fw-medium rounded-3">Access
                                                                        My Records</button>
                                                                </form>
                                                                <div class="text-center mt-4">
                                                                    <a href="index.jsp"
                                                                        class="text-decoration-none small text-muted">Return
                                                                        to Main Website</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <% } else { List<Appointment> appointments =
                                                    dao.getAppointmentsByPatientId(currentUser.getId());
                                                    List<Admission> admissions =
                                                        dao.getAdmissionsByPatientId(currentUser.getId());
                                                        List<PatientReport> reports =
                                                            dao.getReportsByPatientId(currentUser.getId());
                                                            List<User> doctors = dao.getAllDoctors();
                                                                %>
                                                                <!-- Dashboard State -->
                                                                <div class="row g-4">
                                                                    <!-- Personal Info & Booking -->
                                                                    <div class="col-lg-4">
                                                                        <div
                                                                            class="card border-0 shadow-sm rounded-4 mb-4">
                                                                            <div class="card-body p-4">
                                                                                <h5
                                                                                    class="fw-bold mb-3 d-flex align-items-center gap-2">
                                                                                    <i data-lucide="user-circle"
                                                                                        class="text-primary"></i> My
                                                                                    Profile
                                                                                </h5>
                                                                                <div
                                                                                    class="d-flex flex-column gap-2 text-secondary">
                                                                                    <div><strong>Email:</strong>
                                                                                        <%= currentUser.getEmail() %>
                                                                                    </div>
                                                                                    <div><strong>Phone:</strong>
                                                                                        <%= currentUser.getPhone() %>
                                                                                    </div>
                                                                                    <div><strong>Blood Group:</strong>
                                                                                        <span
                                                                                            class="badge bg-danger text-white">
                                                                                            <%= currentUser.getBloodGroup()
                                                                                                %>
                                                                                        </span></div>
                                                                                    <div><strong>Allergies:</strong>
                                                                                        <%= currentUser.getAllergies()
                                                                                            !=null ?
                                                                                            currentUser.getAllergies()
                                                                                            : "None" %>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <div class="card border-0 shadow-sm rounded-4">
                                                                            <div class="card-body p-4">
                                                                                <h5
                                                                                    class="fw-bold mb-3 d-flex align-items-center gap-2">
                                                                                    <i data-lucide="calendar-plus"
                                                                                        class="text-success"></i> Book
                                                                                    Appointment
                                                                                </h5>
                                                                                <form
                                                                                    action="${pageContext.request.contextPath}/patient/bookAppointment"
                                                                                    method="POST">
                                                                                    <div class="mb-3">
                                                                                        <label
                                                                                            class="form-label small fw-medium">Select
                                                                                            Doctor</label>
                                                                                        <select name="doctorId"
                                                                                            class="form-select"
                                                                                            required>
                                                                                            <option value="">Choose...
                                                                                            </option>
                                                                                            <% for(User doc : doctors) {
                                                                                                %>
                                                                                                <option
                                                                                                    value="<%= doc.getId() %>">
                                                                                                    <%= doc.getFullName()
                                                                                                        %> (<%=
                                                                                                            doc.getSpecialization()
                                                                                                            %>)
                                                                                                </option>
                                                                                                <% } %>
                                                                                        </select>
                                                                                    </div>
                                                                                    <div class="mb-3">
                                                                                        <label
                                                                                            class="form-label small fw-medium">Date</label>
                                                                                        <input type="date"
                                                                                            name="appointmentDate"
                                                                                            class="form-control"
                                                                                            required>
                                                                                    </div>
                                                                                    <div class="mb-3">
                                                                                        <label
                                                                                            class="form-label small fw-medium">Time</label>
                                                                                        <input type="time"
                                                                                            name="appointmentTime"
                                                                                            class="form-control"
                                                                                            required>
                                                                                    </div>
                                                                                    <button type="submit"
                                                                                        class="btn btn-success w-100 py-2 rounded-3">Confirm
                                                                                        Booking</button>
                                                                                </form>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <!-- History -->
                                                                    <div class="col-lg-8">
                                                                        <!-- Appointments -->
                                                                        <div
                                                                            class="card border-0 shadow-sm rounded-4 mb-4">
                                                                            <div class="card-body p-4">
                                                                                <h5 class="fw-bold mb-4">Appointment
                                                                                    History</h5>
                                                                                <div class="table-responsive">
                                                                                    <table
                                                                                        class="table table-hover align-middle">
                                                                                        <thead class="bg-light">
                                                                                            <tr>
                                                                                                <th>Date & Time</th>
                                                                                                <th>Doctor</th>
                                                                                                <th>Status</th>
                                                                                            </tr>
                                                                                        </thead>
                                                                                        <tbody>
                                                                                            <% if(appointments.isEmpty())
                                                                                                { %>
                                                                                                <tr>
                                                                                                    <td colspan="3"
                                                                                                        class="text-center text-muted py-3">
                                                                                                        No appointments
                                                                                                        found.</td>
                                                                                                </tr>
                                                                                                <% } else {
                                                                                                    for(Appointment a :
                                                                                                    appointments) { %>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <%= new
                                                                                                                java.text.SimpleDateFormat("MMM
                                                                                                                dd, yyyy
                                                                                                                hh:mm
                                                                                                                a").format(a.getAppointmentTime())
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <%= a.getDoctorName()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <span
                                                                                                                class="badge <%= a.getStatus().equals("
                                                                                                                COMPLETED")
                                                                                                                ? "bg-success"
                                                                                                                :
                                                                                                                a.getStatus().equals("CANCELLED")
                                                                                                                ? "bg-danger"
                                                                                                                : "bg-warning text-dark"
                                                                                                                %>">
                                                                                                                <%= a.getStatus()
                                                                                                                    %>
                                                                                                            </span>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <% } } %>
                                                                                        </tbody>
                                                                                    </table>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Discharge Summaries -->
                                                                        <div
                                                                            class="card border-0 shadow-sm rounded-4 mb-4">
                                                                            <div class="card-body p-4">
                                                                                <h5 class="fw-bold mb-4">Clinical
                                                                                    Discharge Summaries</h5>
                                                                                <% boolean hasSummaries=false;
                                                                                    for(Admission adm : admissions) {
                                                                                    if(adm.getDischargeSummary() !=null
                                                                                    &&
                                                                                    !adm.getDischargeSummary().trim().isEmpty())
                                                                                    { hasSummaries=true; %>
                                                                                    <div
                                                                                        class="border rounded p-3 mb-3 bg-light">
                                                                                        <div
                                                                                            class="d-flex justify-content-between text-muted small mb-2">
                                                                                            <span><strong>Admitted:</strong>
                                                                                                <%= new
                                                                                                    java.text.SimpleDateFormat("MMM
                                                                                                    dd,
                                                                                                    yyyy").format(adm.getAdmissionDate())
                                                                                                    %>
                                                                                            </span>
                                                                                            <span><strong>Discharged:</strong>
                                                                                                <%= new
                                                                                                    java.text.SimpleDateFormat("MMM
                                                                                                    dd,
                                                                                                    yyyy").format(adm.getDischargeDate())
                                                                                                    %>
                                                                                            </span>
                                                                                        </div>
                                                                                        <p class="mb-0 text-dark">
                                                                                            <%= adm.getDischargeSummary()
                                                                                                %>
                                                                                        </p>
                                                                                    </div>
                                                                                    <% } } if(!hasSummaries) { %>
                                                                                        <p
                                                                                            class="text-muted text-center mb-0 py-2">
                                                                                            No past hospital admissions.
                                                                                        </p>
                                                                                        <% } %>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Lab Reports -->
                                                                        <div class="card border-0 shadow-sm rounded-4">
                                                                            <div class="card-body p-4">
                                                                                <h5 class="fw-bold mb-4">Diagnostic
                                                                                    Reports</h5>
                                                                                <% if(reports.isEmpty()) { %>
                                                                                    <p
                                                                                        class="text-muted text-center mb-0 py-2">
                                                                                        No diagnostic reports found.</p>
                                                                                    <% } else { for(PatientReport pr :
                                                                                        reports) { %>
                                                                                        <div
                                                                                            class="border rounded p-3 mb-3">
                                                                                            <div
                                                                                                class="text-primary fw-medium mb-1">
                                                                                                <%= pr.getTestName() %>
                                                                                            </div>
                                                                                            <div
                                                                                                class="text-muted small mb-2">
                                                                                                <%= new
                                                                                                    java.text.SimpleDateFormat("MMM
                                                                                                    dd, yyyy hh:mm
                                                                                                    a").format(pr.getReportDate())
                                                                                                    %>
                                                                                            </div>
                                                                                            <p
                                                                                                class="mb-0 border-start border-3 border-primary ps-3">
                                                                                                <%= pr.getFindings() %>
                                                                                            </p>
                                                                                        </div>
                                                                                        <% } } %>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Chatbot Widget -->
                                                                <div class="chat-widget">
                                                                    <div class="chat-header">
                                                                        <span class="d-flex align-items-center gap-2"><i
                                                                                data-lucide="bot"></i> CareConnect
                                                                            Assistant</span>
                                                                    </div>
                                                                    <div class="chat-body" id="chatBody">
                                                                        <div class="msg msg-bot">Hello <%=
                                                                                currentUser.getFullName().split(" ")[0] %>! I am your AI assistant. How can I help you today?</div>
                </div>
                <div class=" chat-input-area">
                                                                                <input type="text" id="chatInput"
                                                                                    class="chat-input"
                                                                                    placeholder="Ask about hospital..."
                                                                                    onkeypress="handleKeyPress(event)">
                                                                                <button class="chat-btn"
                                                                                    onclick="sendMessage()">
                                                                                    <i data-lucide="send"
                                                                                        style="width: 18px;"></i>
                                                                                </button>
                                                                        </div>
                                                                    </div>

                                                                    <% } %>
                                                                </div>

                                                                <!-- Scripts -->
                                                                <script
                                                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                                                <script>lucide.createIcons();</script>
                                                                <% if (currentUser !=null) { %>
                                                                    <script>
                                                                        // Chatbot Integration Logic
                                                                        const chatBody = document.getElementById('chatBody');
                                                                        const chatInput = document.getElementById('chatInput');
                                                                        const sessionId = "sess_" + Math.random().toString(36).substr(2, 9);

                                                                        function handleKeyPress(e) {
                                                                            if (e.key === 'Enter') {
                                                                                sendMessage();
                                                                            }
                                                                        }

                                                                        async function sendMessage() {
                                                                            const text = chatInput.value.trim();
                                                                            if (!text) return;

                                                                            appendMessage(text, 'msg-user');
                                                                            chatInput.value = '';

                                                                            const loadingId = appendMessage("Thinking...", 'msg-bot');

                                                                            try {
                                                                                const response = await fetch('${pageContext.request.contextPath}/api/chatbot', {
                                                                                    method: 'POST',
                                                                                    headers: { 'Content-Type': 'application/json' },
                                                                                    body: JSON.stringify({
                                                                                        query: text,
                                                                                        session_id: sessionId
                                                                                    })
                                                                                });

                                                                                const data = await response.json();

                                                                                document.getElementById(loadingId).remove();
                                                                                if (data.answer) {
                                                                                    appendMessage(data.answer, 'msg-bot');
                                                                                } else {
                                                                                    appendMessage("I encountered an error connecting to the knowledge base.", 'msg-bot');
                                                                                }

                                                                            } catch (error) {
                                                                                console.error("Chat Error:", error);
                                                                                document.getElementById(loadingId).remove();
                                                                                appendMessage("Failed to connect to the Chatbot service.", 'msg-bot');
                                                                            }
                                                                        }

                                                                        function appendMessage(text, className) {
                                                                            const div = document.createElement('div');
                                                                            div.className = 'msg ' + className;
                                                                            div.innerText = text;
                                                                            const uniqueId = 'msg_' + Date.now();
                                                                            div.id = uniqueId;
                                                                            chatBody.appendChild(div);
                                                                            chatBody.scrollTop = chatBody.scrollHeight;
                                                                            return uniqueId;
                                                                        }
                                                                    </script>
                                                                    <% } %>
                    </body>

                    </html>