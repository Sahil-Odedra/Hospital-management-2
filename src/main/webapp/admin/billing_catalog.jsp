<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<BillingCatalog> catalog = hospitalDAO.getBillingCatalog();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Services & Billing | CareConnect</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        <script src="https://unpkg.com/lucide@latest"></script>
                    </head>

                    <body>
                        <div class="d-flex">
                            <%@ include file="sidebar.jsp" %>
                                <main class="main-content flex-grow-1">
                                    <header class="d-flex justify-content-between align-items-center mb-5 animate-fade">
                                        <div>
                                            <h2 class="mb-1">Services & Billing Catalog</h2>
                                        </div>
                                    </header>

                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success border-0 shadow-sm mb-4 animate-fade">
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
                                                            <h5 class="mb-0 fw-semibold">Billing Master List</h5>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover align-middle mb-0">
                                                                    <thead class="bg-light">
                                                                        <tr>
                                                                            <th
                                                                                class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                ITEM/SERVICE NAME</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                CATEGORY</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                PRICE (INR)</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                ACTION</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% for(BillingCatalog item : catalog) { %>
                                                                            <tr>
                                                                                <td class="ps-4">
                                                                                    <div class="fw-medium text-dark">
                                                                                        <%= item.getItemName() %>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <span
                                                                                        class="badge bg-secondary-subtle text-secondary border-0">
                                                                                        <%= item.getCategory() %>
                                                                                    </span>
                                                                                </td>
                                                                                <td class="fw-medium text-primary">₹<%=
                                                                                        item.getPrice() %>
                                                                                </td>
                                                                                <td class="text-end pe-4">
                                                                                    <a href="${pageContext.request.contextPath}/admin/deleteBillingItem?id=<%= item.getId() %>" 
                                                                                       class="btn btn-sm btn-outline-danger border-0"
                                                                                       onclick="return confirm('Are you sure you want to delete this item?')">
                                                                                        <i data-lucide="trash-2"
                                                                                            style="width: 16px; height: 16px;"></i>
                                                                                    </a>
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
                                                            <h5 class="mb-0 fw-semibold">Add New Service</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/addBillingItem"
                                                                method="POST">
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Service/Item
                                                                        Name</label>
                                                                    <input type="text" name="itemName"
                                                                        class="form-control"
                                                                        placeholder="e.g. CBC Test, ECG" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Category</label>
                                                                    <select name="category" class="form-select"
                                                                        required>
                                                                        <option value="Select" disabled selected>Select Category</option>
                                                                        <option value="Equipment">Equipment</option>
                                                                        <option value="Service">Service</option>
                                                                        <option value="Test">Test</option>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Standard
                                                                        Price (₹)</label>
                                                                    <input type="number" name="price"
                                                                        class="form-control" step="0.01" required>
                                                                </div>
                                                                <button type="submit"
                                                                    class="btn btn-primary w-100 py-2 mt-2">
                                                                    <i data-lucide="plus" class="me-1"
                                                                        style="width: 18px; height: 18px;"></i>
                                                                    Add Service Item
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                </main>
                        </div>
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>lucide.createIcons();</script>
                    </body>

                    </html>