<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<Admission> admissions = hospitalDAO.getAllAdmissions();
                    List<Patient> patients = hospitalDAO.getAllPatients();
                        List<Bed> availableBeds = hospitalDAO.getAvailableBeds();
                            List<User> doctors = hospitalDAO.getAllDoctors();
                                List<BillingCatalog> billingCatalog = hospitalDAO.getBillingCatalog();
                                    %>
                                    <!DOCTYPE html>
                                    <html lang="en">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>IPD Admissions | CareConnect</title>
                                        <link
                                            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
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
                                                            <h2 class="mb-1">Inpatient Admissions (IPD)</h2>
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
                                                                        <div class="card-header bg-white py-3 border-0">
                                                                            <h5 class="mb-0 fw-semibold">Current
                                                                                Admissions
                                                                            </h5>
                                                                        </div>
                                                                        <div class="card-body p-0">
                                                                            <div class="table-responsive">
                                                                                <table
                                                                                    class="table table-hover align-middle mb-0">
                                                                                    <thead class="bg-light">
                                                                                        <tr>
                                                                                            <th
                                                                                                class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                                PATIENT & BED</th>
                                                                                            <th
                                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                                ADMITTED ON</th>
                                                                                            <th
                                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                                DOCTOR</th>
                                                                                            <th
                                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                                STATUS</th>
                                                                                            <th
                                                                                                class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                                ACTION</th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                                        <% for(Admission a : admissions)
                                                                                            { %>
                                                                                            <tr>
                                                                                                <td class="ps-4">
                                                                                                    <div
                                                                                                        class="fw-medium text-dark">
                                                                                                        <%= a.getPatientName()
                                                                                                            %>
                                                                                                    </div>
                                                                                                    <div
                                                                                                        class="text-secondary small">
                                                                                                        Bed <%=
                                                                                                            a.getBedNumber()
                                                                                                            %>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="small">
                                                                                                    <%= a.getAdmissionDate()
                                                                                                        %>
                                                                                                </td>
                                                                                                <td class="small">
                                                                                                    <%= a.getDoctorName()
                                                                                                        %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <% if("Admitted".equals(a.getStatus()))
                                                                                                        { %>
                                                                                                        <span
                                                                                                            class="badge bg-primary-subtle text-primary border-0">Admitted</span>
                                                                                                        <% } else { %>
                                                                                                            <span
                                                                                                                class="badge bg-secondary-subtle text-secondary border-0">
                                                                                                                <%= a.getStatus()
                                                                                                                    %>
                                                                                                            </span>
                                                                                                            <% } %>
                                                                                                </td>
                                                                                                <td
                                                                                                    class="text-end pe-4">
                                                                                                    <% if("Admitted".equals(a.getStatus()))
                                                                                                        { %>
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-outline-primary"
                                                                                                            onclick="openDischargeModal('<%= a.getId() %>', '<%= a.getPatientName() %>', <%= a.getAdmissionDate().getTime() %>, <%= a.getPricePerDay() %>, <%= a.getDepositAmount() %>)">
                                                                                                            Discharge
                                                                                                        </button>
                                                                                                        <% } %>
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
                                                                        <div class="card-header bg-white py-3 border-0">
                                                                            <h5 class="mb-0 fw-semibold">New Admission
                                                                            </h5>
                                                                        </div>
                                                                        <div class="card-body">
                                                                            <form
                                                                                action="${pageContext.request.contextPath}/admin/admitPatient"
                                                                                method="POST">
                                                                                <div class="mb-3">
                                                                                    <label
                                                                                        class="form-label small fw-medium text-secondary">Select
                                                                                        Patient</label>
                                                                                    <select name="patientId"
                                                                                        class="form-select" required>
                                                                                        <% for(Patient p : patients) {
                                                                                            %>
                                                                                            <option
                                                                                                value="<%= p.getId() %>">
                                                                                                <%= p.getFullName() %>
                                                                                            </option>
                                                                                            <% } %>
                                                                                    </select>
                                                                                </div>
                                                                                <div class="mb-3">
                                                                                    <label
                                                                                        class="form-label small fw-medium text-secondary">Assign
                                                                                        Bed</label>
                                                                                    <select name="bedId"
                                                                                        class="form-select" required>
                                                                                        <% for(Bed b : availableBeds) {
                                                                                            %>
                                                                                            <option
                                                                                                value="<%= b.getId() %>">
                                                                                                Bed
                                                                                                <%= b.getBedNumber() %>
                                                                                                    (<%= b.getType() %>)
                                                                                            </option>
                                                                                            <% } %>
                                                                                    </select>
                                                                                </div>
                                                                                <div class="mb-3">
                                                                                    <label
                                                                                        class="form-label small fw-medium text-secondary">Attending
                                                                                        Doctor</label>
                                                                                    <select name="doctorId"
                                                                                        class="form-select" required>
                                                                                        <% for(User d : doctors) { %>
                                                                                            <option
                                                                                                value="<%= d.getId() %>">
                                                                                                <%= d.getFullName() %>
                                                                                            </option>
                                                                                            <% } %>
                                                                                    </select>
                                                                                </div>
                                                                                <div class="mb-3">
                                                                                    <label
                                                                                        class="form-label small fw-medium text-secondary">Insurance
                                                                                        Co. (Optional)</label>
                                                                                    <input type="text"
                                                                                        name="insuranceName"
                                                                                        class="form-control"
                                                                                        placeholder="e.g. LIC, Star Health">
                                                                                </div>
                                                                                <div class="mb-3">
                                                                                    <label
                                                                                        class="form-label small fw-medium text-secondary">Deposit
                                                                                        Amount (₹)</label>
                                                                                    <input type="number"
                                                                                        name="depositAmount"
                                                                                        class="form-control"
                                                                                        placeholder="0.00" required>
                                                                                </div>
                                                                                <button type="submit"
                                                                                    class="btn btn-primary w-100 py-2 mt-2">
                                                                                    <i data-lucide="check" class="me-1"
                                                                                        style="width: 18px; height: 18px;"></i>
                                                                                    Confirm Admission
                                                                                </button>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                </main>
                                        </div>

                                        <!-- Discharge Modal -->
                                        <div class="modal fade" id="dischargeModal" tabindex="-1">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content border-0 shadow shadow-lg">
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/dischargePatient"
                                                        method="POST">
                                                        <input type="hidden" name="id" id="dischargeAdmissionId">
                                                        <div class="modal-header border-0">
                                                            <h5 class="modal-title fw-bold">Process Discharge & Billing
                                                            </h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row g-4">
                                                                <div class="col-md-6 border-end">
                                                                    <label class="form-label fw-bold small">Discharge
                                                                        Summary</label>
                                                                    <textarea name="summary" class="form-control mb-3"
                                                                        rows="10"
                                                                        placeholder="Treatment summary, follow-up advice..."
                                                                        required></textarea>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label fw-bold small">Services &
                                                                        Procedures (Used)</label>
                                                                    <div class="service-checklist border rounded p-3"
                                                                        style="max-height: 250px; overflow-y: auto;">
                                                                        <% for(BillingCatalog item : billingCatalog) {
                                                                            %>
                                                                            <div class="form-check mb-2">
                                                                                <input
                                                                                    class="form-check-input billing-item"
                                                                                    type="checkbox" name="billingItems"
                                                                                    value="<%= item.getId() %>"
                                                                                    data-price="<%= item.getPrice() %>"
                                                                                    id="item-<%= item.getId() %>">
                                                                                <label
                                                                                    class="form-check-label d-flex justify-content-between small"
                                                                                    for="item-<%= item.getId() %>">
                                                                                    <span>
                                                                                        <%= item.getItemName() %>
                                                                                    </span>
                                                                                    <span class="text-muted">₹<%=
                                                                                            item.getPrice() %></span>
                                                                                </label>
                                                                            </div>
                                                                            <% } %>
                                                                    </div>
                                                                    <div class="mt-4 p-3 bg-light rounded">
                                                                        <div
                                                                            class="d-flex justify-content-between align-items-center mb-1">
                                                                            <span class="small text-secondary">Base Bed
                                                                                Charges:</span>
                                                                            <span class="small fw-medium"
                                                                                id="previewBedCharges">Calculating...</span>
                                                                        </div>
                                                                        <div id="previewDepositContainer"
                                                                            class="d-flex justify-content-between align-items-center mb-1 d-none">
                                                                            <span class="small text-danger">Less
                                                                                Admission Deposit:</span>
                                                                            <span class="small fw-medium text-danger"
                                                                                id="previewDeposit">-₹0.00</span>
                                                                        </div>
                                                                        <div
                                                                            class="d-flex justify-content-between align-items-center pt-2 border-top">
                                                                            <span class="fw-bold">Total Bill:</span>
                                                                            <span class="fw-bold text-primary"
                                                                                id="previewTotal">₹0.00</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer border-0">
                                                            <button type="button" class="btn btn-light"
                                                                data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary px-4">Generate
                                                                Bill & Discharge</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <script
                                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                        <script>
                                            lucide.createIcons();

                                            let currentBedPrice = 0;
                                            let currentAdmissionDate = null;
                                            let currentDeposit = 0;

                                            function openDischargeModal(id, name, admissionDate, bedPrice, deposit) {
                                                document.getElementById('dischargeAdmissionId').value = id;
                                                currentBedPrice = bedPrice;
                                                currentAdmissionDate = new Date(admissionDate);
                                                currentDeposit = deposit;

                                                // Reset checkboxes
                                                document.querySelectorAll('.billing-item').forEach(cb => cb.checked = false);

                                                calculateBill();
                                                new bootstrap.Modal(document.getElementById('dischargeModal')).show();
                                            }

                                            function calculateBill() {
                                                const now = new Date();
                                                const diffTime = Math.abs(now - currentAdmissionDate);
                                                const days = Math.max(1, Math.ceil(diffTime / (1000 * 60 * 60 * 24)));

                                                const bedCharges = days * currentBedPrice;
                                                document.getElementById('previewBedCharges').innerText = "₹" + bedCharges.toLocaleString() + " (" + days + " days)";

                                                let total = bedCharges;
                                                document.querySelectorAll('.billing-item:checked').forEach(item => {
                                                    total += parseFloat(item.getAttribute('data-price'));
                                                });

                                                if (currentDeposit > 0) {
                                                    document.getElementById('previewDepositContainer').classList.remove('d-none');
                                                    document.getElementById('previewDeposit').innerText = "-₹" + currentDeposit.toLocaleString();
                                                    total -= currentDeposit;
                                                    if (total < 0) total = 0;
                                                } else {
                                                    document.getElementById('previewDepositContainer').classList.add('d-none');
                                                }

                                                document.getElementById('previewTotal').innerText = "₹" + total.toLocaleString();
                                            }

                                            document.querySelectorAll('.billing-item').forEach(item => {
                                                item.addEventListener('change', calculateBill);
                                            });
                                        </script>
                                    </body>

                                    </html>