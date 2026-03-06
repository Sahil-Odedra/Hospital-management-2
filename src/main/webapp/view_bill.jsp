<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.util.concurrent.TimeUnit" %>
                <%@ page import="java.sql.Timestamp" %>
                    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                        <% User user=(User) session.getAttribute("user"); if (user==null) {
                            response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } int
                            admissionId=Integer.parseInt(request.getParameter("admissionId")); HospitalDAO dao=new
                            HospitalDAO(); Admission admission=dao.getAdmissionById(admissionId); if (admission==null) {
                            out.println("Invalid Admission ID"); return; } List<PatientReport> reports =
                            dao.getReportsByAdmissionId(admissionId);
                            List<Medicine> prescribedMeds = dao.getPrescribedMedicinesByAdmissionId(admissionId);

                                // Calculate Stay Days
                                long diffInMillis;
                                if (admission.getDischargeDate() != null) {
                                diffInMillis = admission.getDischargeDate().getTime() -
                                admission.getAdmissionDate().getTime();
                                } else {
                                diffInMillis = new java.util.Date().getTime() - admission.getAdmissionDate().getTime();
                                }
                                long days = TimeUnit.MILLISECONDS.toDays(diffInMillis);
                                if (days == 0) days = 1; // Minimum 1 day charge

                                double bedRate = 1200.0; // Fallback
                                double bedTotal = days * bedRate;

                                double labTotal = 0;
                                for(PatientReport r : reports) {
                                labTotal += 500; // Fixed per test for demo
                                }

                                double pharmacyTotal = 0;
                                for(Medicine m : prescribedMeds) {
                                pharmacyTotal += (m.getPricePerUnit() * m.getCurrentStock()); // prescribed quantity was
                                stored in currentStock for bill object
                                }

                                double total = bedTotal + labTotal + pharmacyTotal;
                                double netPayable = total - admission.getDepositAmount();
                                %>
                                <!DOCTYPE html>
                                <html lang="en">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Invoice - <%= admission.getPatientName() %> | CareConnect</title>
                                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                        rel="stylesheet">
                                    <script src="https://unpkg.com/lucide@latest"></script>
                                    <style>
                                        :root {
                                            --primary: #0f172a;
                                            --accent: #3b82f6;
                                        }

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
                                            background: var(--primary);
                                            color: white;
                                            padding: 3rem;
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

                                        .total-section {
                                            border-top: 2px solid var(--primary);
                                        }

                                        @media print {
                                            .no-print {
                                                display: none !important;
                                            }

                                            body {
                                                background: white;
                                            }

                                            .invoice-card {
                                                box-shadow: none !important;
                                            }
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="container py-5">
                                        <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                                            <a href="admin/manage_admissions.jsp" class="btn btn-light border">
                                                <i data-lucide="arrow-left" class="me-2" style="width: 18px;"></i> Back
                                                to Admissions
                                            </a>
                                            <button onclick="window.print()" class="btn btn-primary">
                                                <i data-lucide="printer" class="me-2" style="width: 18px;"></i> Print
                                                Invoice
                                            </button>
                                        </div>

                                        <div class="card invoice-card shadow-lg mx-auto" style="max-width: 900px;">
                                            <div
                                                class="invoice-header d-flex justify-content-between align-items-start">
                                                <div>
                                                    <div class="d-flex align-items-center gap-2 mb-3">
                                                        <i data-lucide="activity"
                                                            style="width: 32px; height: 32px;"></i>
                                                        <h2 class="mb-0 fw-bold">CareConnect</h2>
                                                    </div>
                                                    <p class="mb-0 opacity-75">123 Health Ave, Medical District</p>
                                                    <p class="mb-0 opacity-75">Mumbai, MH 400001</p>
                                                    <p class="mb-0 opacity-75">support@careconnect.in</p>
                                                </div>
                                                <div class="text-end">
                                                    <h1 class="display-6 fw-bold mb-1">INVOICE</h1>
                                                    <p class="mb-0">Reference: #INV-<%= admission.getId() %>
                                                            <%= System.currentTimeMillis() % 1000 %>
                                                    </p>
                                                    <p class="mb-0">Date: <%= new java.text.SimpleDateFormat("dd MMM
                                                            yyyy").format(new java.util.Date()) %>
                                                    </p>
                                                </div>
                                            </div>

                                            <div class="card-body p-5">
                                                <div class="row mb-5">
                                                    <div class="col-6">
                                                        <h6 class="text-secondary text-uppercase small fw-bold mb-3">
                                                            Bill To:</h6>
                                                        <h4 class="fw-bold mb-1">
                                                            <%= admission.getPatientName() %>
                                                        </h4>
                                                        <p class="text-secondary mb-0">Admission ID: <%=
                                                                admission.getId() %>
                                                        </p>
                                                        <p class="text-secondary mb-0">Insurance: <%=
                                                                (admission.getInsuranceName() !=null &&
                                                                !admission.getInsuranceName().isEmpty()) ?
                                                                admission.getInsuranceName() : "No Insurance" %>
                                                        </p>
                                                    </div>
                                                    <div class="col-6 text-end">
                                                        <h6 class="text-secondary text-uppercase small fw-bold mb-3">
                                                            Stay Details:</h6>
                                                        <p class="mb-0"><span class="fw-bold">From:</span>
                                                            <%= new java.text.SimpleDateFormat("dd/MM/yyyy
                                                                HH:mm").format(admission.getAdmissionDate()) %>
                                                        </p>
                                                        <p class="mb-0"><span class="fw-bold">To:</span>
                                                            <%= (admission.getDischargeDate() !=null) ? new
                                                                java.text.SimpleDateFormat("dd/MM/yyyy
                                                                HH:mm").format(admission.getDischargeDate())
                                                                : "Currently Admitted" %>
                                                        </p>
                                                        <p class="mb-0"><span class="fw-bold">Duration:</span>
                                                            <%= days %> Day(s)
                                                        </p>
                                                    </div>
                                                </div>

                                                <div class="table-responsive mb-5">
                                                    <table class="table bill-table">
                                                        <thead>
                                                            <tr>
                                                                <th class="ps-0">Description</th>
                                                                <th class="text-center">Rate</th>
                                                                <th class="text-center">Quantity</th>
                                                                <th class="text-end pe-0">Total</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td class="ps-0">
                                                                    <div class="fw-bold">Bed Charges</div>
                                                                    <div class="small text-secondary">Bed <%=
                                                                            admission.getBedNumber() %> (Standard Rate)
                                                                    </div>
                                                                </td>
                                                                <td class="text-center">₹<%= bedRate %>
                                                                </td>
                                                                <td class="text-center">
                                                                    <%= days %>
                                                                </td>
                                                                <td class="text-end pe-0 fw-bold">₹<%= bedTotal %>
                                                                </td>
                                                            </tr>
                                                            <% for(PatientReport r : reports) { %>
                                                                <tr>
                                                                    <td class="ps-0">
                                                                        <div class="fw-bold">
                                                                            <%= r.getTestName() %>
                                                                        </div>
                                                                        <div class="small text-secondary">Diagnostic Lab
                                                                            Test</div>
                                                                    </td>
                                                                    <td class="text-center">₹500.00</td>
                                                                    <td class="text-center">1</td>
                                                                    <td class="text-end pe-0 fw-bold">₹500.00</td>
                                                                </tr>
                                                                <% } %>
                                                                    <% for(Medicine m : prescribedMeds) { %>
                                                                        <tr>
                                                                            <td class="ps-0">
                                                                                <div class="fw-bold">
                                                                                    <%= m.getName() %>
                                                                                </div>
                                                                                <div class="small text-secondary">
                                                                                    Pharmacy Item</div>
                                                                            </td>
                                                                            <td class="text-center">₹<%=
                                                                                    m.getPricePerUnit() %>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <%= m.getCurrentStock() %>
                                                                            </td>
                                                                            <td class="text-end pe-0 fw-bold">₹<%=
                                                                                    (m.getPricePerUnit() *
                                                                                    m.getCurrentStock()) %>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>

                                                <div class="row justify-content-end pt-4">
                                                    <div class="col-lg-5">
                                                        <div class="d-flex justify-content-between mb-2">
                                                            <span class="text-secondary">Subtotal</span>
                                                            <span class="fw-bold">₹<%= total %></span>
                                                        </div>
                                                        <div class="d-flex justify-content-between mb-4">
                                                            <span class="text-secondary">Deduct: Security Deposit</span>
                                                            <span class="text-danger fw-bold">- ₹<%=
                                                                    admission.getDepositAmount() %></span>
                                                        </div>
                                                        <div
                                                            class="d-flex justify-content-between align-items-center p-3 total-section bg-light rounded-3">
                                                            <h4 class="mb-0 fw-bold">Net Payable</h4>
                                                            <h2 class="mb-0 fw-bold text-primary">₹<%= netPayable %>
                                                            </h2>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="mt-5 pt-5 text-center border-top">
                                                    <p class="small text-secondary mb-0">This is a computer-generated
                                                        invoice. No signature required.</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <script>lucide.createIcons();</script>
                                </body>

                                </html>