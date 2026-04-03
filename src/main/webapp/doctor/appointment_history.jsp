<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.careconnect.HospitalDAO, com.careconnect.Entities.*, java.util.*, java.text.SimpleDateFormat"
        %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect("../index.jsp"); return; } HospitalDAO dao=new HospitalDAO(); List<Appointment>
            appointments = dao.getAppointmentsByDoctor(user.getId());
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Appointment History - CareConnect HMS</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    .badge-completed {
                        background-color: #dcfce7;
                        color: #166534;
                        padding: 0.5rem 1rem;
                        border-radius: 9999px;
                        font-weight: 500;
                        font-size: 0.75rem;
                    }
                </style>
            </head>

            <body>
                <div class="d-flex">
                    <jsp:include page="sidebar.jsp" />

                    <main class="main-content flex-grow-1">
                    <div class="container-fluid">
                        <div class="row mb-4">
                            <div class="col-12">
                                <h3 class="fw-bold text-dark">Appointment History</h3>
                                <p class="text-secondary">View all your completed consultations and prescriptions.</p>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="bg-light">
                                            <tr>
                                                <th class="px-4 py-3">Patient Name</th>
                                                <th class="py-3">Date & Time</th>
                                                <th class="py-3">Status</th>
                                                <th class="py-3">Notes</th>
                                                <th class="px-4 py-3 text-end">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% boolean hasCompleted=false; for (Appointment appt : appointments) { if
                                                ("COMPLETED".equals(appt.getStatus())) { hasCompleted=true; %>
                                                <tr>
                                                    <td class="px-4">
                                                        <div class="fw-semibold text-dark">
                                                            <%= appt.getPatientName() %>
                                                        </div>
                                                        <div class="text-secondary small">ID: #<%= appt.getPatientId()
                                                                %>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="small fw-medium">
                                                            <i data-lucide="calendar" class="me-1 text-primary"
                                                                style="width: 14px;"></i>
                                                            <%= sdf.format(appt.getAppointmentTime()) %>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge-completed">COMPLETED</span>
                                                    </td>
                                                    <td class="text-secondary small">
                                                        <%= appt.getAdminNotes() !=null ? appt.getAdminNotes() : "N/A"
                                                            %>
                                                    </td>
                                                    <td class="px-4 text-end">
                                                        <button class="btn btn-outline-primary btn-sm rounded-pill px-3"
                                                            onclick="viewPrescription(<%= appt.getId() %>)">
                                                            View Details
                                                        </button>
                                                    </td>
                                                </tr>
                                                <% } } if (!hasCompleted) { %>
                                                    <tr>
                                                        <td colspan="5" class="text-center py-5">
                                                            <div class="text-secondary py-3">
                                                                <i data-lucide="inbox" class="mb-3 opacity-20"
                                                                    style="width: 48px; height: 48px;"></i>
                                                                <h6>No completed appointments yet</h6>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>

                <!-- Modal for Prescription Details -->
                <div class="modal fade" id="prescriptionModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-xl);">
                            <div class="modal-header border-0 pb-0">
                                <h5 class="modal-title fw-bold">Prescription Details</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body pb-4" id="prescriptionBody">
                                <!-- Loaded via AJAX -->
                                <div class="text-center py-5">
                                    <div class="spinner-border text-primary" role="status"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://unpkg.com/lucide@latest"></script>
                <script>
                    lucide.createIcons();

                    async function viewPrescription(apptId) {
                        const modal = new bootstrap.Modal(document.getElementById('prescriptionModal'));
                        modal.show();

                        const container = document.getElementById('prescriptionBody');
                        container.innerHTML = '<div class="text-center py-5"><div class="spinner-border text-primary"></div></div>';

                        try {
                            const response = await fetch('getPrescriptionHistory?appointmentId=' + apptId);
                            const data = await response.text();
                            container.innerHTML = data;
                            lucide.createIcons();
                        } catch (error) {
                            container.innerHTML = '<div class="alert alert-danger">Error loading prescription details.</div>';
                        }
                    }
                </script>
            </body>

            </html>