<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<Bed> beds = hospitalDAO.getAllBeds();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Bed Management | CareConnect</title>
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
                                            <h2 class="mb-1">Room & Bed Management</h2>
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
                                                            <h5 class="mb-0 fw-semibold">Unit Directory</h5>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover align-middle mb-0">
                                                                    <thead class="bg-light">
                                                                        <tr>
                                                                            <th
                                                                                class="ps-4 py-3 text-secondary small fw-semibold">
                                                                                BED/ROOM</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                TYPE & FLOOR</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                DAILY PRICE</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold">
                                                                                STATUS</th>
                                                                            <th
                                                                                class="py-3 text-secondary small fw-semibold text-end pe-4">
                                                                                ACTION</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% for(Bed b : beds) { %>
                                                                            <tr>
                                                                                <td class="ps-4">
                                                                                    <div class="fw-medium text-dark">Bed
                                                                                        <%= b.getBedNumber() %>
                                                                                    </div>
                                                                                    <div class="text-secondary small">
                                                                                        Room <%= b.getRoomNumber() %>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <span
                                                                                        class="badge bg-secondary-subtle text-secondary border-0">
                                                                                        <%= b.getType() %>
                                                                                    </span>
                                                                                    <div
                                                                                        class="text-secondary small mt-1">
                                                                                        Floor <%= b.getFloor() %>
                                                                                    </div>
                                                                                </td>
                                                                                <td class="fw-medium text-primary">₹<%=
                                                                                        b.getPricePerDay() %>
                                                                                </td>
                                                                                <td>
                                                                                    <% if("Available".equals(b.getStatus()))
                                                                                        { %>
                                                                                        <span
                                                                                            class="badge bg-success-subtle text-success border-0">Available</span>
                                                                                        <% } else
                                                                                            if("Occupied".equals(b.getStatus()))
                                                                                            { %>
                                                                                            <span
                                                                                                class="badge bg-danger-subtle text-danger border-0">Occupied</span>
                                                                                            <% } else { %>
                                                                                                <span
                                                                                                    class="badge bg-warning-subtle text-warning border-0">Maintenance</span>
                                                                                                <% } %>
                                                                                </td>
                                                                                <td class="text-end pe-4">
                                                                                    <a href="${pageContext.request.contextPath}/admin/deleteBed?id=<%= b.getId() %>" 
                                                                                       class="btn btn-sm btn-outline-danger border-0"
                                                                                       onclick="return confirm('Are you sure you want to delete this bed?')">
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
                                                            <h5 class="mb-0 fw-semibold">Add New Unit</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/addBed"
                                                                method="POST">
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Bed
                                                                        Number</label>
                                                                    <input type="text" name="bedNumber"
                                                                        class="form-control" placeholder="e.g. 101A"
                                                                        required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Room
                                                                        Number</label>
                                                                    <input type="text" name="roomNumber"
                                                                        class="form-control" placeholder="e.g. 101"
                                                                        required>
                                                                </div>
                                                                <div class="row g-2 mb-3">
                                                                    <div class="col-md-6">
                                                                        <label
                                                                            class="form-label small fw-medium text-secondary">Floor</label>
                                                                        <input type="number" name="floor"
                                                                            class="form-control" required>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label
                                                                            class="form-label small fw-medium text-secondary">Ward
                                                                            Type</label>
                                                                        <select name="type" class="form-select"
                                                                            required>
                                                                            <option value="Common">Common</option>
                                                                            <option value="Semi-Special">Semi-Special
                                                                            </option>
                                                                            <option value="Special">Special</option>
                                                                            <option value="ICU">ICU</option>
                                                                            <option value="Premium">Premium</option>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label small fw-medium text-secondary">Daily
                                                                        Charge (₹)</label>
                                                                    <input type="number" name="pricePerDay"
                                                                        class="form-control" step="0.01" required>
                                                                </div>
                                                                <button type="submit"
                                                                    class="btn btn-primary w-100 py-2 mt-2">
                                                                    <i data-lucide="plus" class="me-1"
                                                                        style="width: 18px; height: 18px;"></i>
                                                                    Add Bed / Unit
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