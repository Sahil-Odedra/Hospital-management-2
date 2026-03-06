<%@ page import="com.careconnect.Entities.*" %>
    <%@ page import="com.careconnect.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO dao=new
                    HospitalDAO(); List<Medicine> medicines = dao.getAllMedicines();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Manage Pharmacy | CareConnect Admin</title>
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
                                            <h2 class="mb-1">Pharmacy Inventory</h2>
                                        </div>
                                        <div>
                                            <button class="btn btn-primary" data-bs-toggle="modal"
                                                data-bs-target="#addMedicineModal">
                                                <i data-lucide="plus" style="width:16px;"></i> Add New Medicine
                                            </button>
                                            <a href="dashboard.jsp" class="btn btn-outline-secondary ms-2">Back to
                                                Dashboard</a>
                                        </div>
                                    </header>

                                    <% if(session.getAttribute("message") !=null) { %>
                                        <div class="alert alert-success alert-dismissible fade show">
                                            <%= session.getAttribute("message") %>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="alert"></button>
                                        </div>
                                        <% session.removeAttribute("message"); %>
                                            <% } %>

                                                <% if(session.getAttribute("error") !=null) { %>
                                                    <div class="alert alert-danger alert-dismissible fade show">
                                                        <%= session.getAttribute("error") %>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="alert"></button>
                                                    </div>
                                                    <% session.removeAttribute("error"); %>
                                                        <% } %>

                                                            <div class="card border-0 shadow-sm animate-fade"
                                                                style="border-radius: var(--radius-xl); animation-delay: 0.1s;">
                                                                <div class="card-body p-0">
                                                                    <div class="table-responsive">
                                                                        <table
                                                                            class="table table-hover align-middle mb-0">
                                                                            <thead class="bg-light">
                                                                                <tr>
                                                                                    <th class="ps-4 py-3">NAME</th>
                                                                                    <th class="py-3">BATCH NO</th>
                                                                                    <th class="py-3">EXPIRY DATE</th>
                                                                                    <th class="py-3 text-center">STOCK
                                                                                    </th>
                                                                                    <th class="py-3 text-center">PRICE
                                                                                    </th>
                                                                                    <th class="py-3 text-end pe-4">
                                                                                        ACTIONS</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <% for(Medicine m : medicines) { %>
                                                                                    <tr>
                                                                                        <td class="ps-4 fw-medium">
                                                                                            <%= m.getName() %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= m.getBatchNo() %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <span
                                                                                                class='<%= m.getExpiryDate().before(new java.util.Date()) ? "text-danger fw-bold" : "" %>'>
                                                                                                <%= m.getExpiryDate() %>
                                                                                            </span>
                                                                                        </td>
                                                                                        <td class="text-center">
                                                                                            <% if(m.getCurrentStock()
                                                                                                <=m.getLowStockThreshold())
                                                                                                { %>
                                                                                                <span
                                                                                                    class="badge bg-danger text-white border-0">
                                                                                                    <%= m.getCurrentStock()
                                                                                                        %> (CRITICAL)
                                                                                                </span>
                                                                                                <% } else { %>
                                                                                                    <span
                                                                                                        class="badge bg-success-subtle text-success">
                                                                                                        <%= m.getCurrentStock()
                                                                                                            %>
                                                                                                    </span>
                                                                                                    <% } %>
                                                                                        </td>
                                                                                        <td class="text-center">₹<%=
                                                                                                m.getPricePerUnit() %>
                                                                                        </td>
                                                                                        <td class="text-end pe-4">
                                                                                            <button
                                                                                                class="btn btn-sm btn-outline-primary"
                                                                                                onclick="openStockModal('<%= m.getId() %>', '<%= m.getName() %>', <%= m.getCurrentStock() %>)">
                                                                                                <i data-lucide="package-plus"
                                                                                                    style="width:14px;"></i>
                                                                                                Stock
                                                                                            </button>
                                                                                            <button
                                                                                                class="btn btn-sm btn-outline-danger ms-1"
                                                                                                onclick="confirmDelete('<%= m.getId() %>')">
                                                                                                <i data-lucide="trash-2"
                                                                                                    style="width:14px;"></i>
                                                                                            </button>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <% } %>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </div>
                                                            </div>
                                </main>
                        </div>

                        <!-- Add Medicine Modal -->
                        <div class="modal fade" id="addMedicineModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content border-0 shadow shadow-lg">
                                    <div class="modal-header border-0">
                                        <h5 class="modal-title fw-bold">Add New Medicine</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/MedicineServlet" method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label class="form-label small fw-medium text-secondary">Medicine
                                                    Name</label>
                                                <input type="text" name="name" class="form-control"
                                                    placeholder="e.g. Paracetamol 500mg" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label small fw-medium text-secondary">Batch
                                                    No</label>
                                                <input type="text" name="batchNo" class="form-control"
                                                    placeholder="e.g. B-902">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label small fw-medium text-secondary">Expiry
                                                    Date</label>
                                                <input type="date" name="expiryDate" class="form-control" required>
                                            </div>
                                            <div class="row g-2 mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-medium text-secondary">Initial
                                                        Stock</label>
                                                    <input type="number" name="currentStock" class="form-control"
                                                        required min="0">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-medium text-secondary">Low Stock
                                                        Alert Level</label>
                                                    <input type="number" name="lowStockThreshold" class="form-control"
                                                        value="20" required>
                                                </div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label small fw-medium text-secondary">Supplier
                                                    Email</label>
                                                <input type="email" name="supplierEmail" class="form-control"
                                                    placeholder="supplier@example.com">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label small fw-medium text-secondary">Price Per Unit
                                                    (₹)</label>
                                                <input type="number" step="0.01" name="price" class="form-control"
                                                    required min="0">
                                            </div>
                                        </div>
                                        <div class="modal-footer border-0">
                                            <button type="button" class="btn btn-light"
                                                data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Save to Inventory</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Update Stock Modal -->
                        <div class="modal fade" id="updateStockModal" tabindex="-1">
                            <div class="modal-dialog modal-sm">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Update Stock</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/MedicineServlet" method="POST"
                                        onsubmit="return prepareStockUpdate()">
                                        <input type="hidden" name="action" value="updateStock">
                                        <input type="hidden" name="id" id="stockId">
                                        <input type="hidden" name="quantity" id="finalQuantity">
                                        <input type="hidden" id="currentStockValue">

                                        <div class="modal-body">
                                            <p id="stockMedicineName" class="fw-bold mb-1 text-primary"></p>
                                            <p class="small text-secondary mb-3">Current Stock: <span
                                                    id="displayCurrentStock" class="fw-bold text-dark"></span></p>

                                            <div class="mb-3">
                                                <label class="form-label small text-secondary fw-bold">OPERATION</label>
                                                <div class="btn-group w-100" role="group">
                                                    <input type="radio" class="btn-check" name="stockOp" id="opAdd"
                                                        value="add" checked>
                                                    <label class="btn btn-outline-success" for="opAdd">
                                                        <i data-lucide="plus" style="width:14px"></i> Add
                                                    </label>

                                                    <input type="radio" class="btn-check" name="stockOp" id="opRemove"
                                                        value="remove">
                                                    <label class="btn btn-outline-danger" for="opRemove">
                                                        <i data-lucide="minus" style="width:14px"></i> Remove
                                                    </label>
                                                </div>
                                            </div>

                                            <label class="form-label">Quantity</label>
                                            <input type="number" id="inputQuantity" class="form-control" required
                                                min="1">
                                        </div>
                                        <div class="modal-footer">
                                            <button type="submit" class="btn btn-primary w-100">Update Stock</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Delete Form (Hidden) -->
                        <form id="deleteForm" action="${pageContext.request.contextPath}/MedicineServlet" method="POST">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" id="deleteId">
                        </form>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            lucide.createIcons();

                            function openStockModal(id, name, currentStock) {
                                document.getElementById('stockId').value = id;
                                document.getElementById('stockMedicineName').innerText = name;
                                document.getElementById('displayCurrentStock').innerText = currentStock;
                                document.getElementById('currentStockValue').value = currentStock;
                                document.getElementById('inputQuantity').value = '';
                                document.getElementById('opAdd').checked = true;
                                new bootstrap.Modal(document.getElementById('updateStockModal')).show();
                            }

                            function prepareStockUpdate() {
                                const qty = parseInt(document.getElementById('inputQuantity').value);
                                const op = document.querySelector('input[name="stockOp"]:checked').value;
                                const currentStock = parseInt(document.getElementById('currentStockValue').value);

                                if (op === 'remove') {
                                    if (qty > currentStock) {
                                        alert('Cannot remove more items than currently in stock! (Max: ' + currentStock + ')');
                                        return false;
                                    }
                                    document.getElementById('finalQuantity').value = -qty;
                                } else {
                                    document.getElementById('finalQuantity').value = qty;
                                }
                                return true;
                            }

                            function confirmDelete(id) {
                                if (confirm('Are you sure you want to delete this medicine?')) {
                                    document.getElementById('deleteId').value = id;
                                    document.getElementById('deleteForm').submit();
                                }
                            }
                        </script>
                    </body>

                    </html>