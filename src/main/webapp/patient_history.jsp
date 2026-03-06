<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.*" %>
            <%@ page import="java.text.SimpleDateFormat" %>
                <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                    <% User user=(User) session.getAttribute("user"); if (user==null) {
                        response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } int
                        patientId=Integer.parseInt(request.getParameter("patientId")); HospitalDAO dao=new
                        HospitalDAO(); Patient patient=dao.getPatientById(patientId); if (patient==null) {
                        out.println("Patient not found."); return; } List<Appointment> appointments =
                        dao.getAppointmentsByPatient(patientId);
                        List<Admission> admissions = dao.getAdmissionsByPatient(patientId);
                            List<PatientReport> reports = dao.getReportsByPatient(patientId);

                                // Sort all events chronologically if needed, or group them.
                                // We'll show sections for better readability.
                                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, HH:mm");
                                %>
                                <!DOCTYPE html>
                                <html lang="en">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Clinical History - <%= patient.getFullName() %> | CareConnect</title>
                                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                        rel="stylesheet">
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                        rel="stylesheet">
                                    <script src="https://unpkg.com/lucide@latest"></script>
                                    <style>
                                        :root {
                                            --primary: #3b82f6;
                                            --bg: #f8fafc;
                                        }

                                        body {
                                            font-family: 'Inter', sans-serif;
                                            background: var(--bg);
                                        }

                                        .history-card {
                                            border-radius: 1.25rem;
                                            border: none;
                                            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
                                        }

                                        .timeline {
                                            position: relative;
                                            padding-left: 2rem;
                                            border-left: 2px solid #e2e8f0;
                                            margin-left: 1rem;
                                        }

                                        .timeline-item {
                                            position: relative;
                                            margin-bottom: 2.5rem;
                                        }

                                        .timeline-item::before {
                                            content: '';
                                            position: absolute;
                                            left: -2.4rem;
                                            top: 0.25rem;
                                            width: 12px;
                                            height: 12px;
                                            border-radius: 50%;
                                            background: var(--primary);
                                            border: 3px solid white;
                                            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
                                        }

                                        .item-type {
                                            font-size: 0.75rem;
                                            font-weight: 700;
                                            text-transform: uppercase;
                                            letter-spacing: 0.05em;
                                            padding: 0.25rem 0.75rem;
                                            border-radius: 2rem;
                                            margin-bottom: 0.5rem;
                                            display: inline-block;
                                        }

                                        .type-opd {
                                            background: #dbeafe;
                                            color: #1e40af;
                                        }

                                        .type-ipd {
                                            background: #fef3c7;
                                            color: #92400e;
                                        }

                                        .type-lab {
                                            background: #dcfce7;
                                            color: #166534;
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="container py-5">
                                        <div class="d-flex justify-content-between align-items-center mb-5">
                                            <div>
                                                <a href="admin/manage_patients.jsp"
                                                    class="btn btn-link text-decoration-none p-0 mb-2">
                                                    <i data-lucide="arrow-left" class="me-1" style="width: 16px;"></i>
                                                    Back to Patients
                                                </a>
                                                <h1 class="fw-bold mb-0">Clinical Timeline</h1>
                                                <p class="text-secondary mb-0">
                                                    <%= patient.getFullName() %> • ID: #PAT-<%= patient.getId() %>
                                                </p>
                                            </div>
                                            <div class="text-end">
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-lg-3">
                                                <div class="card history-card mb-4 bg-white p-4 sticky-top"
                                                    style="top: 2rem; border: 1px solid #e1e7ec;">
                                                    <div class="d-flex align-items-center mb-4">
                                                        <div
                                                            class="bg-primary bg-opacity-10 text-primary p-2 rounded me-3">
                                                            <i data-lucide="user" style="width: 24px;"></i>
                                                        </div>
                                                        <h5 class="fw-bold mb-0 text-dark">Patient Profile</h5>
                                                    </div>

                                                    <div class="mb-4">
                                                        <div
                                                            class="small text-secondary fw-semibold text-uppercase letter-spacing-1 mb-1 d-flex align-items-center">
                                                            <i data-lucide="droplet" class="me-1 text-danger"
                                                                style="width:14px"></i> Blood Group
                                                        </div>
                                                        <div class="fw-bold fs-5 text-dark">
                                                            <%= patient.getBloodGroup() !=null ? patient.getBloodGroup()
                                                                : "N/A" %>
                                                        </div>
                                                    </div>

                                                    <div class="mb-4">
                                                        <div
                                                            class="small text-secondary fw-semibold text-uppercase letter-spacing-1 mb-1 d-flex align-items-center">
                                                            <i data-lucide="map-pin" class="me-1 text-primary"
                                                                style="width:14px"></i> Address
                                                        </div>
                                                        <div class="fw-medium text-dark">
                                                            <%= patient.getAddress() !=null ? patient.getAddress()
                                                                : "Not provided" %>
                                                        </div>
                                                    </div>

                                                    <div class="mb-2">
                                                        <div
                                                            class="small text-secondary fw-semibold text-uppercase letter-spacing-1 mb-1 d-flex align-items-center">
                                                            <i data-lucide="phone-call" class="me-1 text-success"
                                                                style="width:14px"></i> Emergency Contact
                                                        </div>
                                                        <div class="fw-medium text-dark">
                                                            <%= patient.getEmergencyContactName() !=null ?
                                                                patient.getEmergencyContactName() : "N/A" %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-lg-9">
                                                <div class="card history-card p-4 p-md-5">
                                                    <div class="timeline">
                                                        <!-- Admissions (IPD) -->
                                                        <% for(Admission a : admissions) { %>
                                                            <div class="timeline-item">
                                                                <span class="item-type type-ipd">Inpatient Stay
                                                                    (IPD)</span>
                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <h5 class="fw-bold mb-0">Admission: Bed <%=
                                                                            a.getBedNumber() %>
                                                                    </h5>
                                                                    <small class="text-secondary fw-medium">
                                                                        <%= sdf.format(a.getAdmissionDate()) %>
                                                                    </small>
                                                                </div>
                                                                <div
                                                                    class="bg-white p-4 rounded-3 shadow-sm mb-3 border">
                                                                    <div class="row g-4">
                                                                        <div class="col-sm-6">
                                                                            <div
                                                                                class="small fw-semibold text-secondary text-uppercase letter-spacing-1 mb-2 d-flex align-items-center">
                                                                                <i data-lucide="stethoscope"
                                                                                    class="me-1" style="width:14px"></i>
                                                                                Primary Doctor
                                                                            </div>
                                                                            <div class="fw-bold fs-6 text-dark">
                                                                                <%= a.getDoctorName() %>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-sm-6">
                                                                            <div
                                                                                class="small fw-semibold text-secondary text-uppercase letter-spacing-1 mb-2 d-flex align-items-center">
                                                                                <i data-lucide="activity" class="me-1"
                                                                                    style="width:14px"></i> Status
                                                                            </div>
                                                                            <% String statusClass="Admitted"
                                                                                .equals(a.getStatus())
                                                                                ? "text-primary bg-primary bg-opacity-10 px-2 py-1 rounded"
                                                                                : "text-success bg-success bg-opacity-10 px-2 py-1 rounded"
                                                                                ; %>
                                                                                <div
                                                                                    class="fw-bold d-inline-block <%= statusClass %>">
                                                                                    <%= a.getStatus() %>
                                                                                </div>
                                                                        </div>
                                                                        <% if(a.getDischargeDate() !=null) { %>
                                                                            <div
                                                                                class="col-12 mt-3 pt-3 border-top border-light">
                                                                                <div
                                                                                    class="small fw-semibold text-secondary text-uppercase letter-spacing-1 mb-2 d-flex align-items-center">
                                                                                    <i data-lucide="file-text"
                                                                                        class="me-1"
                                                                                        style="width:14px"></i>
                                                                                    Discharge Summary
                                                                                </div>
                                                                                <div
                                                                                    class="text-dark fst-italic ps-3 border-start border-3 border-light">
                                                                                    <%= a.getDischargeSummary() %>
                                                                                </div>
                                                                            </div>
                                                                            <% } %>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <% } %>

                                                                <!-- Appointments (OPD) -->
                                                                <% for(Appointment appt : appointments) {
                                                                    List<Prescription> apptPrescriptions =
                                                                    dao.getPrescriptionsByAppointment(appt.getId());
                                                                    %>
                                                                    <div class="timeline-item">
                                                                        <span class="item-type type-opd">OPD
                                                                            Consultation</span>
                                                                        <div
                                                                            class="d-flex justify-content-between align-items-start mb-2">
                                                                            <h5 class="fw-bold mb-0">Record: <%=
                                                                                    appt.getDoctorName() %>
                                                                            </h5>
                                                                            <small class="text-secondary fw-medium">
                                                                                <%= sdf.format(appt.getAppointmentTime())
                                                                                    %>
                                                                            </small>
                                                                        </div>

                                                                        <div
                                                                            class="bg-white p-4 rounded-3 shadow-sm mb-3 border">
                                                                            <div class="row g-4 mb-3">
                                                                                <div class="col-sm-6">
                                                                                    <div
                                                                                        class="small fw-semibold text-secondary text-uppercase letter-spacing-1 mb-2 d-flex align-items-center">
                                                                                        <i data-lucide="file-text"
                                                                                            class="me-1"
                                                                                            style="width:14px"></i>
                                                                                        Clinical Notes
                                                                                    </div>
                                                                                    <div
                                                                                        class="fw-medium text-dark ps-3 border-start border-3 border-light">
                                                                                        <%= appt.getAdminNotes() !=null
                                                                                            &&
                                                                                            !appt.getAdminNotes().trim().isEmpty()
                                                                                            ? appt.getAdminNotes()
                                                                                            : "<span class=\" text-muted
                                                                                            fst-italic\">No notes
                                                                                            recorded</span>" %>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-sm-6">
                                                                                    <div
                                                                                        class="small fw-semibold text-secondary text-uppercase letter-spacing-1 mb-2 d-flex align-items-center">
                                                                                        <i data-lucide="activity"
                                                                                            class="me-1"
                                                                                            style="width:14px"></i>
                                                                                        Status
                                                                                    </div>
                                                                                    <span
                                                                                        class="badge bg-light text-dark border px-3 py-2 rounded-pill fw-medium">
                                                                                        <%= appt.getStatus() %>
                                                                                    </span>
                                                                                </div>
                                                                            </div>

                                                                            <% if(!apptPrescriptions.isEmpty()) { %>
                                                                                <div class="border-top pt-3 mt-2">
                                                                                    <h6
                                                                                        class="small fw-bold text-primary mb-3">
                                                                                        MEDICINES & DOSAGE</h6>
                                                                                    <div class="table-responsive">
                                                                                        <table
                                                                                            class="table table-sm table-borderless mb-0 align-middle">
                                                                                            <thead
                                                                                                class="bg-light small">
                                                                                                <tr>
                                                                                                    <th class="ps-2">
                                                                                                        Medicine</th>
                                                                                                    <th
                                                                                                        class="text-center">
                                                                                                        M-N-E-Nt</th>
                                                                                                    <th>Duration</th>
                                                                                                    <th
                                                                                                        class="text-end pe-2">
                                                                                                        Qty</th>
                                                                                                </tr>
                                                                                            </thead>
                                                                                            <tbody class="small">
                                                                                                <% for(Prescription p :
                                                                                                    apptPrescriptions) {
                                                                                                    List<PrescriptionDetail>
                                                                                                    details =
                                                                                                    dao.getPrescriptionDetails(p.getId());
                                                                                                    for(PrescriptionDetail
                                                                                                    pd : details) {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td
                                                                                                            class="ps-2 fw-medium">
                                                                                                            <i data-lucide="pill"
                                                                                                                class="text-secondary me-1"
                                                                                                                style="width:12px;"></i>
                                                                                                            <%= pd.getMedicineName()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td
                                                                                                            class="text-center">
                                                                                                            <span
                                                                                                                class="badge bg-primary-subtle text-primary border-0">
                                                                                                                <%= pd.getDosageMorning()
                                                                                                                    %>
                                                                                                            </span>
                                                                                                            <span
                                                                                                                class="badge bg-warning-subtle text-warning-emphasis border-0">
                                                                                                                <%= pd.getDosageNoon()
                                                                                                                    %>
                                                                                                            </span>
                                                                                                            <span
                                                                                                                class="badge bg-info-subtle text-info-emphasis border-0">
                                                                                                                <%= pd.getDosageEvening()
                                                                                                                    %>
                                                                                                            </span>
                                                                                                            <span
                                                                                                                class="badge bg-dark-subtle text-dark-emphasis border-0">
                                                                                                                <%= pd.getDosageNight()
                                                                                                                    %>
                                                                                                            </span>
                                                                                                        </td>
                                                                                                        <td
                                                                                                            class="text-secondary">
                                                                                                            <%= pd.getDuration()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td
                                                                                                            class="text-end pe-2 fw-bold text-dark">
                                                                                                            <%= pd.getQuantity()
                                                                                                                %>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <% } } %>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>
                                                                        </div>
                                                                    </div>
                                                                    <% } %>

                                                                        <!-- Reports -->
                                                                        <% for(PatientReport r : reports) { %>
                                                                            <div class="timeline-item">
                                                                                <span
                                                                                    class="item-type type-lab">Diagnostic
                                                                                    Report</span>
                                                                                <div
                                                                                    class="d-flex justify-content-between align-items-start mb-3">
                                                                                    <h5 class="fw-bold mb-0 text-dark">
                                                                                        <%= r.getTestName() %>
                                                                                    </h5>
                                                                                    <small
                                                                                        class="text-secondary fw-medium">
                                                                                        <%= sdf.format(r.getTestDate())
                                                                                            %>
                                                                                    </small>
                                                                                </div>
                                                                                <div
                                                                                    class="bg-white p-4 rounded-3 shadow-sm mb-3 border border-success border-opacity-25">
                                                                                    <div
                                                                                        class="small fw-semibold text-secondary text-uppercase letter-spacing-1 mb-2 d-flex align-items-center">
                                                                                        <i data-lucide="microscope"
                                                                                            class="me-1 text-success"
                                                                                            style="width:14px"></i>
                                                                                        Clinical Findings:
                                                                                    </div>
                                                                                    <div
                                                                                        class="fw-medium text-dark ps-3 border-start border-3 border-success border-opacity-25">
                                                                                        <%= r.getFindings() %>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <% } %>

                                                                                <% if(admissions.isEmpty() &&
                                                                                    appointments.isEmpty() &&
                                                                                    reports.isEmpty()) { %>
                                                                                    <div class="text-center py-5">
                                                                                        <i data-lucide="file-x-2"
                                                                                            class="text-secondary mb-3"
                                                                                            style="width: 48px; height: 48px;"></i>
                                                                                        <h5 class="text-secondary">No
                                                                                            recorded history found for
                                                                                            this patient.</h5>
                                                                                    </div>
                                                                                    <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <script>lucide.createIcons();</script>
                                </body>

                                </html>