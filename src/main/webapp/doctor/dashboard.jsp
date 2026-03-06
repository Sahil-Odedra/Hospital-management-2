<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"DOCTOR".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<Appointment> appointments =
                    hospitalDAO.getAppointmentsByDoctor(user.getId());
                    List<Medicine> medicines = hospitalDAO.getAllMedicines();
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
                            <style>
                                .medicine-row {
                                    transition: all 0.3s ease;
                                }

                                .medicine-row:hover {
                                    background-color: #f8f9fa;
                                }
                            </style>
                        </head>

                        <body>
                            <div class="d-flex">
                                <%@ include file="sidebar.jsp" %>

                                    <main class="main-content flex-grow-1">
                                        <header
                                            class="d-flex justify-content-between align-items-center mb-5 animate-fade">
                                            <div>
                                                <h2 class="mb-1">Medical Dashboard</h2>
                                            </div>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="text-end">
                                                    <div class="fw-semibold text-dark">
                                                        <%= user.getFullName() %>
                                                    </div>
                                                    <div class="text-secondary small">
                                                        <%= user.getSpecialization() %>
                                                    </div>
                                                </div>
                                            </div>
                                        </header>

                                        <!-- Alerts -->
                                        <% if(session.getAttribute("message") !=null) { %>
                                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                                <%= session.getAttribute("message") %>
                                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                        aria-label="Close"></button>
                                            </div>
                                            <% session.removeAttribute("message"); %>
                                                <% } %>

                                                    <% if(session.getAttribute("error") !=null) { %>
                                                        <div class="alert alert-danger alert-dismissible fade show"
                                                            role="alert">
                                                            <%= session.getAttribute("error") %>
                                                                <button type="button" class="btn-close"
                                                                    data-bs-dismiss="alert" aria-label="Close"></button>
                                                        </div>
                                                        <% session.removeAttribute("error"); %>
                                                            <% } %>

                                                                <div class="row g-4 animate-fade"
                                                                    style="animation-delay: 0.1s;">
                                                                    <div class="col-lg-12">
                                                                        <div class="card border-0 shadow-sm"
                                                                            style="border-radius: var(--radius-xl);">
                                                                            <div
                                                                                class="card-header bg-white py-4 border-0 d-flex justify-content-between align-items-center">
                                                                                <h5 class="mb-0 fw-semibold">Upcoming
                                                                                    Appointments</h5>
                                                                                <span
                                                                                    class="badge bg-primary-subtle text-primary px-3 py-2">
                                                                                    <%= appointments.size() %> SCHEDULED
                                                                                </span>
                                                                            </div>
                                                                            <div class="card-body p-0">
                                                                                <% if (appointments.isEmpty()) { %>
                                                                                    <div class="text-center py-5">
                                                                                        <div
                                                                                            class="mb-3 text-muted opacity-25">
                                                                                            <i data-lucide="calendar-x"
                                                                                                style="width: 64px; height: 64px;"></i>
                                                                                        </div>
                                                                                        <h6 class="text-secondary">No
                                                                                            appointments scheduled today
                                                                                        </h6>
                                                                                        <p class="small text-muted">
                                                                                            You're all caught up!</p>
                                                                                    </div>
                                                                                    <% } else { %>
                                                                                        <div class="table-responsive">
                                                                                            <table
                                                                                                class="table table-hover align-middle mb-0">
                                                                                                <thead class="bg-light">
                                                                                                    <tr>
                                                                                                        <th
                                                                                                            class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                                            TIME & DATE
                                                                                                        </th>
                                                                                                        <th
                                                                                                            class="py-3 text-secondary small fw-semibold">
                                                                                                            PATIENT NAME
                                                                                                        </th>
                                                                                                        <th
                                                                                                            class="py-3 text-secondary small fw-semibold">
                                                                                                            ADMIN NOTES
                                                                                                        </th>
                                                                                                        <th
                                                                                                            class="py-3 text-secondary small fw-semibold">
                                                                                                            STATUS</th>
                                                                                                        <th
                                                                                                            class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                                            ACTIONS</th>
                                                                                                    </tr>
                                                                                                </thead>
                                                                                                <tbody>
                                                                                                    <% for(Appointment
                                                                                                        appt :
                                                                                                        appointments) {
                                                                                                        %>
                                                                                                        <tr>
                                                                                                            <td
                                                                                                                class="ps-4">
                                                                                                                <div
                                                                                                                    class="d-flex align-items-center gap-2">
                                                                                                                    <i data-lucide="clock"
                                                                                                                        class="text-primary"
                                                                                                                        style="width: 16px; height: 16px;"></i>
                                                                                                                    <span
                                                                                                                        <div
                                                                                                                        class="fw-medium">
                                                                                                                        <%= appt.getDoctorName()
                                                                                                                            %>
                                                                                                                            <%= appt.getAppointmentTime()
                                                                                                                                %>
                                                                                                                    </span>
                                                                                                                </div>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <div
                                                                                                                    class="fw-semibold text-dark">
                                                                                                                    <%= appt.getPatientName()
                                                                                                                        %>
                                                                                                                </div>
                                                                                                            </td>
                                                                                                            <td
                                                                                                                class="text-secondary small">
                                                                                                                <%= (appt.getAdminNotes()
                                                                                                                    !=null
                                                                                                                    &&
                                                                                                                    !appt.getAdminNotes().isEmpty())
                                                                                                                    ?
                                                                                                                    appt.getAdminNotes()
                                                                                                                    : "<span class='text-muted italic'>No notes provided</span>"
                                                                                                                    %>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <span
                                                                                                                    class="badge bg-warning-subtle text-warning-emphasis px-2 py-1">
                                                                                                                    <%= appt.getStatus()
                                                                                                                        %>
                                                                                                                </span>
                                                                                                            </td>
                                                                                                            <td
                                                                                                                class="text-end pe-4">
                                                                                                                <% if(!"COMPLETED".equals(appt.getStatus()))
                                                                                                                    { %>
                                                                                                                    <button
                                                                                                                        class="btn btn-sm btn-primary"
                                                                                                                        onclick="openPrescriptionModal('<%= appt.getId() %>', '<%= appt.getPatientId() %>', '<%= appt.getPatientName() %>')">
                                                                                                                        Prescribe
                                                                                                                    </button>
                                                                                                                    <% } else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span
                                                                                                                            class="text-success small fw-semibold"><i
                                                                                                                                data-lucide="check-circle"
                                                                                                                                style="width:14px;"></i>
                                                                                                                            Completed</span>
                                                                                                                        <% }
                                                                                                                            %>
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

                            <!-- Prescription Modal -->
                            <div class="modal fade" id="prescriptionModal" tabindex="-1">
                                <div class="modal-dialog modal-lg modal-dialog-centered">
                                    <div class="modal-content border-0 shadow-lg">
                                        <div class="modal-header bg-primary text-white">
                                            <h5 class="modal-title">Prescribe Medicine</h5>
                                            <button type="button" class="btn-close btn-close-white"
                                                data-bs-dismiss="modal"></button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/PrescriptionServlet"
                                            method="POST">
                                            <div class="modal-body p-4">
                                                <input type="hidden" name="appointmentId" id="modalApptId">
                                                <input type="hidden" name="patientId" id="modalPatientId">

                                                <div class="mb-4">
                                                    <label
                                                        class="form-label fw-semibold text-secondary small">PATIENT</label>
                                                    <input type="text" class="form-control bg-light"
                                                        id="modalPatientName" readonly>
                                                </div>

                                                <div class="mb-4">
                                                    <label
                                                        class="form-label fw-semibold text-secondary small">DIAGNOSIS</label>
                                                    <textarea name="diagnosis" class="form-control" rows="3"
                                                        required></textarea>
                                                </div>

                                                <div class="mb-3 d-flex justify-content-between align-items-center">
                                                    <label
                                                        class="form-label fw-semibold text-secondary small mb-0">PRESCRIPTIONS</label>
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                        onclick="addMedicineRow()">
                                                        <i data-lucide="plus" style="width:16px;"></i> Add Medicine
                                                    </button>
                                                </div>

                                                <div id="medicineContainer">
                                                    <!-- Dynamic Rows will appear here -->
                                                </div>
                                            </div>
                                            <div class="modal-footer bg-light">
                                                <button type="button"
                                                    class="btn btn-link text-secondary text-decoration-none"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary px-4">Submit
                                                    Prescription</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            <script>
                                lucide.createIcons();

                                function openPrescriptionModal(apptId, patientId, patientName) {
                                    document.getElementById('modalApptId').value = apptId;
                                    document.getElementById('modalPatientId').value = patientId;
                                    document.getElementById('modalPatientName').value = patientName;

                                    // Clear previous medicines
                                    document.getElementById('medicineContainer').innerHTML = '';
                                    addMedicineRow(); // Add one initial row

                                    new bootstrap.Modal(document.getElementById('prescriptionModal')).show();
                                }

                                function addMedicineRow() {
                                    const container = document.getElementById('medicineContainer');
                                    const rowId = Date.now();

                                    const html = `
                <div class="row g-2 mb-2 medicine-row align-items-end border-bottom pb-3" id="row-${rowId}">
                    <div class="col-md-3">
                        <label class="small text-muted mb-1 d-block">Medicine</label>
                        <select name="medicineId" class="form-select form-select-sm" required>
                            <option value="">Select Medicine</option>
                            <% for(Medicine m : medicines) { %>
                                <option value="<%= m.getId() %>"><%= m.getName() %> (Stock: <%= m.getCurrentStock() %>)</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="small text-muted mb-1 d-block">Dosage (M - N - E - Night)</label>
                        <div class="d-flex align-items-center gap-1">
                            <input type="number" name="dosageMorning" class="form-control form-control-sm text-center" placeholder="M" title="Morning" value="0" oninput="calculateQty('${rowId}')">
                            <span class="text-muted">-</span>
                            <input type="number" name="dosageNoon" class="form-control form-control-sm text-center" placeholder="N" title="Noon" value="0" oninput="calculateQty('${rowId}')">
                            <span class="text-muted">-</span>
                            <input type="number" name="dosageEvening" class="form-control form-control-sm text-center" placeholder="E" title="Evening" value="0" oninput="calculateQty('${rowId}')">
                            <span class="text-muted">-</span>
                            <input type="number" name="dosageNight" class="form-control form-control-sm text-center" placeholder="Nt" title="Night" value="0" oninput="calculateQty('${rowId}')">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <label class="small text-muted mb-1 d-block">Duration (Days)</label>
                        <input type="number" name="duration" class="form-control form-control-sm" placeholder="Days" required oninput="calculateQty('${rowId}')">
                    </div>
                    <div class="col-md-2">
                        <label class="small text-muted mb-1 d-block">Qty</label>
                        <input type="number" name="quantity" class="form-control form-control-sm bg-light" min="1" value="1" readonly required>
                    </div>
                    <div class="col-md-1 text-end">
                        <button type="button" class="btn btn-link text-danger p-0" onclick="removeRow('${rowId}')">
                            <i data-lucide="trash-2" style="width:16px;"></i>
                        </button>
                    </div>
                </div>
            `;
                                    container.insertAdjacentHTML('beforeend', html);
                                    lucide.createIcons();
                                }

                                function calculateQty(rowId) {
                                    const row = document.getElementById('row-' + rowId);
                                    const m = parseInt(row.querySelector('[name="dosageMorning"]').value) || 0;
                                    const n = parseInt(row.querySelector('[name="dosageNoon"]').value) || 0;
                                    const e = parseInt(row.querySelector('[name="dosageEvening"]').value) || 0;
                                    const nt = parseInt(row.querySelector('[name="dosageNight"]').value) || 0;
                                    const duration = parseInt(row.querySelector('[name="duration"]').value) || 0;

                                    const qty = (m + n + e + nt) * duration;
                                    row.querySelector('[name="quantity"]').value = qty > 0 ? qty : 1;
                                }

                                function removeRow(rowId) {
                                    document.getElementById('row-' + rowId).remove();
                                }
                            </script>
                        </body>

                        </html>