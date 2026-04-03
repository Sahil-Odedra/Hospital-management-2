<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.text.SimpleDateFormat" %>
                <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                    <% User user=(User) session.getAttribute("user"); if (user==null) {
                        response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } 
                        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                        HospitalDAO dao = new HospitalDAO(); 
                        // Fetch Billing first 
                        Billing bill = dao.getBillByAppointment(appointmentId); 
                        if (bill == null) { 
                            out.println("<div class='container py-5 text-center'>" +
                                        "<h3>Bill not generated yet.</h3>" +
                                        "<p>Completion of prescription is required.</p>" +
                                        "</div>"); 
                            return;
                        }

                        List<Prescription> prescriptions = dao.getPrescriptionsByAppointment(appointmentId);
                            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, HH:mm");
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <title>OPD Invoice | CareConnect</title>
                                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                    rel="stylesheet">
                                <script src="https://unpkg.com/lucide@latest"></script>
                                <style>
                                    body {
                                        background: #f8fafc;
                                        font-family: 'Inter', sans-serif;
                                    }

                                    .invoice-card {
                                        background: white;
                                        border-radius: 1.5rem;
                                        border: none;
                                        overflow: hidden;
                                    }

                                    .invoice-header {
                                        background: #0f172a;
                                        color: white;
                                        padding: 2.5rem;
                                    }

                                    .bill-table th {
                                        background: #f1f5f9;
                                        text-transform: uppercase;
                                        font-size: 0.75rem;
                                        letter-spacing: 0.05em;
                                        border: none;
                                    }

                                    .bill-table td {
                                        border-bottom: 1px solid #f1f5f9;
                                        padding: 1.25rem 0.75rem;
                                    }

                                    @media print {
                                        .no-print {
                                            display: none !important;
                                        }
                                    }
                                </style>
                            </head>

                            <body>
                                <div class="container py-5">
                                    <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                                        <a href="admin/manage_appointments.jsp" class="btn btn-light border">
                                            <i data-lucide="arrow-left" class="me-2" style="width: 18px;"></i> Back to
                                            Directory
                                        </a>
                                        <button onclick="window.print()" class="btn btn-primary">
                                            <i data-lucide="printer" class="me-2" style="width: 18px;"></i> Print OPD
                                            Invoice
                                        </button>
                                    </div>

                                    <div class="card invoice-card shadow-lg mx-auto" style="max-width: 800px;">
                                        <div class="invoice-header d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="d-flex align-items-center gap-2 mb-2">
                                                    <i data-lucide="activity" style="width: 28px;"></i>
                                                    <h3 class="mb-0 fw-bold">CareConnect</h3>
                                                </div>
                                                <p class="mb-0 small opacity-75">OPD Services Division</p>
                                            </div>
                                            <div class="text-end">
                                                <h2 class="fw-bold mb-0">OPD INVOICE</h2>
                                                <p class="mb-0 small opacity-75">#OPD-<%= bill.getId() %>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="card-body p-4 p-md-5">
                                            <div class="row mb-4">
                                                <div class="col-6">
                                                    <h6 class="text-secondary text-uppercase small fw-bold mb-2">Patient
                                                        Details</h6>
                                                    <h4 class="fw-bold mb-0">
                                                        <%= bill.getPatientName() %>
                                                    </h4>
                                                    <p class="text-secondary small">Patient ID: #PAT-<%=
                                                            bill.getPatientId() %>
                                                    </p>
                                                </div>
                                                <div class="col-6 text-end">
                                                    <h6 class="text-secondary text-uppercase small fw-bold mb-2">Visit
                                                        Date</h6>
                                                    <p class="fw-bold mb-0">
                                                        <% SimpleDateFormat sdfDate=new SimpleDateFormat("dd MMM yyyy");
                                                            sdfDate.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Kolkata"));
                                                            SimpleDateFormat sdfTime=new SimpleDateFormat("HH:mm");
                                                            sdfTime.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Kolkata"));
                                                            %>
                                                            <%= sdfDate.format(bill.getBillingDate()) %>
                                                    </p>
                                                    <p class="text-secondary small">Time: <%=
                                                            sdfTime.format(bill.getBillingDate()) %>
                                                    </p>
                                                </div>
                                            </div>

                                            <div class="table-responsive mb-4">
                                                <table class="table bill-table">
                                                    <thead>
                                                        <tr>
                                                            <th class="ps-0">Service Description</th>
                                                            <th class="text-end pe-0">Amount</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td class="ps-0">
                                                                <div class="fw-bold">Consultation Fee</div>
                                                                <div class="small text-secondary">OPD Visit Record #<%=
                                                                        appointmentId %>
                                                                </div>
                                                            </td>
                                                            <td class="text-end pe-0 fw-bold">₹500.0</td>
                                                        </tr>
                                                        <% if(bill.getTotalAmount() > 500.0) { %>
                                                        <tr>
                                                            <td class="ps-0">
                                                                <div class="fw-bold">Pharmacy & Medicines</div>
                                                                <div class="small text-secondary">Cost of newly prescribed items</div>
                                                            </td>
                                                            <td class="text-end pe-0 fw-bold">₹<%= bill.getTotalAmount() - 500.0 %></td>
                                                        </tr>
                                                        <% } %>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <div class="row justify-content-end mb-5">
                                                <div class="col-6 col-md-4">
                                                    <div class="d-flex justify-content-between p-3 bg-light rounded-3">
                                                        <span class="fw-bold">TOTAL</span>
                                                        <span class="fw-bold text-primary h4 mb-0">₹<%=
                                                                bill.getTotalAmount() %></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <% if(!prescriptions.isEmpty()) { %>
                                                <div class="mt-4 p-4 border rounded-3 bg-light">
                                                    <h6 class="fw-bold text-uppercase small mb-3">Pharmacy Memo
                                                        (Clinical)</h6>
                                                    <% for(Prescription p : prescriptions) { List<PrescriptionDetail>
                                                        details = dao.getPrescriptionDetails(p.getId());
                                                        %>
                                                        <div class="mb-2">
                                                            <div class="small fw-bold">Diagnosis: <%= p.getDiagnosis()
                                                                    %>
                                                            </div>
                                                            <ul class="list-unstyled mb-0 ms-2 mt-2">
                                                                <% for(PrescriptionDetail pd : details) { %>
                                                                    <li class="small text-secondary mb-1">
                                                                        • <%= pd.getMedicineName() %> (<%=
                                                                                pd.getDosageMorning() %>-<%=
                                                                                    pd.getDosageNoon() %>-<%=
                                                                                        pd.getDosageEvening() %>-<%=
                                                                                            pd.getDosageNight() %>) for
                                                                                            <%= pd.getDuration() %>
                                                                    </li>
                                                                    <% } %>
                                                            </ul>
                                                        </div>
                                                        <% } %>
                                                </div>
                                                <% } %>

                                                    <div class="mt-5 text-center text-secondary small pt-4 border-top">
                                                        Thank you for choosing CareConnect. Please keep this invoice for
                                                        your medical records.
                                                    </div>
                                        </div>
                                    </div>
                                </div>
                                <script>lucide.createIcons();</script>
                            </body>

                            </html>