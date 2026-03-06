<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.sql.Connection" %>
                <%@ page import="java.sql.PreparedStatement" %>
                    <%@ page import="java.sql.ResultSet" %>
                        <%@ page import="com.careconnect.DBConnection" %>
                            <%@ page import="java.text.SimpleDateFormat" %>
                                <%@ page import="java.util.TimeZone" %>
                                    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                                        <% User user=(User) session.getAttribute("user"); if (user==null ||
                                            !"ADMIN".equals(user.getRole())) {
                                            response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; }
                                            int billId=Integer.parseInt(request.getParameter("id")); HospitalDAO
                                            hospitalDAO=new HospitalDAO(); /* Fetch bill details */ Billing bill=null;
                                            String
                                            billSql="SELECT b.*, p.full_name as patient_name, p.address as patient_address, p.phone as patient_phone "
                                            + "FROM billing b JOIN patients p ON b.patient_id = p.id WHERE b.id = ?" ;
                                            try (Connection conn=DBConnection.getConnection(); PreparedStatement
                                            ps=conn.prepareStatement(billSql)) { ps.setInt(1, billId); ResultSet
                                            rs=ps.executeQuery(); if (rs.next()) { bill=new Billing();
                                            bill.setId(rs.getInt("id"));
                                            bill.setPatientName(rs.getString("patient_name"));
                                            bill.setTotalAmount(rs.getDouble("total_amount"));
                                            bill.setPaidAmount(rs.getDouble("paid_amount"));
                                            bill.setPaymentStatus(rs.getString("payment_status"));
                                            bill.setBillingDate(rs.getTimestamp("billing_date")); } } if (bill==null) {
                                            out.println("Bill not found."); return; } %>
                                            <!DOCTYPE html>
                                            <html lang="en">

                                            <head>
                                                <meta charset="UTF-8">
                                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                                <title>Invoice #<%= bill.getId() %> | CareConnect</title>
                                                <link
                                                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                                    rel="stylesheet">
                                                <link rel="stylesheet"
                                                    href="${pageContext.request.contextPath}/css/style.css">
                                                <style>
                                                    @media print {
                                                        .no-print {
                                                            display: none !important;
                                                        }

                                                        .card {
                                                            border: none !important;
                                                            box-shadow: none !important;
                                                        }

                                                        body {
                                                            background: white !important;
                                                        }
                                                    }

                                                    .invoice-header {
                                                        border-bottom: 2px solid var(--primary-color);
                                                    }
                                                </style>
                                                <!-- html2pdf.js -->
                                                <script
                                                    src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
                                            </head>

                                            <body class="bg-light">
                                                <div class="container py-5">
                                                    <div class="row justify-content-center">
                                                        <div class="col-lg-8">
                                                            <div class="no-print d-flex justify-content-between mb-4">
                                                                <a href="manage_admissions.jsp"
                                                                    class="btn btn-light border">
                                                                    Back to Admissions
                                                                </a>
                                                                <div>
                                                                    <button onclick="downloadPDF()"
                                                                        class="btn btn-outline-primary me-2">
                                                                        <i data-lucide="download" class="me-1"
                                                                            style="width: 16px; height: 16px;"></i>
                                                                        Download PDF
                                                                    </button>
                                                                    <button onclick="window.print()"
                                                                        class="btn btn-primary">
                                                                        <i data-lucide="printer" class="me-1"
                                                                            style="width: 16px; height: 16px;"></i>
                                                                        Print
                                                                        Invoice
                                                                    </button>
                                                                </div>
                                                            </div>

                                                            <div id="invoice-content"
                                                                class="card border-0 shadow-sm p-5"
                                                                style="border-radius: 20px;">
                                                                <div
                                                                    class="invoice-header pb-4 mb-5 d-flex justify-content-between align-items-center">
                                                                    <div>
                                                                        <h2 class="fw-bold text-primary mb-1">
                                                                            CareConnect</h2>
                                                                    </div>
                                                                    <div class="text-end">
                                                                        <h4 class="fw-bold mb-0">INVOICE</h4>
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-5">
                                                                    <div class="col-6">
                                                                        <p class="text-secondary small mb-1">Billed To:
                                                                        </p>
                                                                        <h5 class="fw-bold mb-1">
                                                                            <%= bill.getPatientName() %>
                                                                        </h5>
                                                                    </div>
                                                                    <div class="col-6 text-end">
                                                                        <p class="text-secondary small mb-1">Date:</p>
                                                                        <h5 class="fw-bold mb-0">
                                                                            <% SimpleDateFormat sdf=new
                                                                                SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                                                                sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));
                                                                                %>
                                                                                <%= sdf.format(bill.getBillingDate()) %>
                                                                        </h5>
                                                                    </div>
                                                                </div>

                                                                <div class="table-responsive mb-5">
                                                                    <table class="table">
                                                                        <thead class="bg-light">
                                                                            <tr>
                                                                                <th class="py-3">Description</th>
                                                                                <th class="py-3 text-end">Amount</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <% String
                                                                                detailsSql="SELECT * FROM billing_details WHERE billing_id = ?"
                                                                                ; try (Connection
                                                                                conn=DBConnection.getConnection();
                                                                                PreparedStatement
                                                                                ps=conn.prepareStatement(detailsSql)) {
                                                                                ps.setInt(1, billId); ResultSet
                                                                                rs=ps.executeQuery(); while (rs.next())
                                                                                { %>
                                                                                <tr>
                                                                                    <td class="py-3">
                                                                                        <%= rs.getString("item_name") %>
                                                                                    </td>
                                                                                    <td class="py-3 text-end fw-medium">
                                                                                        ₹<%= String.format("%.2f",
                                                                                            rs.getDouble("amount")) %>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } } %>
                                                                        </tbody>
                                                                    </table>
                                                                </div>

                                                                <div class="row justify-content-end">
                                                                    <div class="col-md-5">
                                                                        <div
                                                                            class="d-flex justify-content-between mb-2">
                                                                            <span class="text-secondary">Subtotal</span>
                                                                            <span class="fw-medium">₹<%=
                                                                                    String.format("%.2f",
                                                                                    bill.getTotalAmount()) %></span>
                                                                        </div>
                                                                        <div
                                                                            class="d-flex justify-content-between mb-3">
                                                                            <span class="text-secondary">Tax (0%)</span>
                                                                            <span
                                                                                class="fw-medium text-success">Included</span>
                                                                        </div>
                                                                        <div
                                                                            class="d-flex justify-content-between pt-3 border-top">
                                                                            <h4 class="fw-bold">Total</h4>
                                                                            <h4 class="fw-bold text-primary">₹<%=
                                                                                    String.format("%.2f",
                                                                                    bill.getTotalAmount()) %>
                                                                            </h4>
                                                                        </div>

                                                                        <div
                                                                            class="mt-4 p-3 bg-light rounded text-center">
                                                                            <% String badgeClass="Paid"
                                                                                .equals(bill.getPaymentStatus())
                                                                                ? "bg-success" : "bg-warning text-dark"
                                                                                ; %>
                                                                                <span class="badge <%= badgeClass %>">
                                                                                    <%= bill.getPaymentStatus() %>
                                                                                </span>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <footer
                                                                    class="mt-5 pt-5 border-top text-center text-secondary small">
                                                                    <p>Thank you for choosing CareConnect. We wish you a
                                                                        speedy
                                                                        recovery!</p>
                                                                    <p class="mb-0">This is a computer generated
                                                                        invoice.</p>
                                                                </footer>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Required Scripts -->
                                                <script src="https://unpkg.com/lucide@latest"></script>
                                                <script
                                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                                <script>
                                                    lucide.createIcons();

                                                    function downloadPDF() {
                                                        const element = document.getElementById('invoice-content');
                                                        const opt = {
                                                            margin: 0.5,
                                                            filename: 'CareConnect_Invoice_INV-<%= bill.getId() %>.pdf',
                                                            image: { type: 'jpeg', quality: 0.98 },
                                                            html2canvas: { scale: 2, useCORS: true },
                                                            jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
                                                        };

                                                        // Generate the PDF
                                                        html2pdf().set(opt).from(element).save();
                                                    }
                                                </script>
                                            </body>

                                            </html>