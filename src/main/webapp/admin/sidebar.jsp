<%@ page contentType="text/html;charset=UTF-8" %>
    <div class="sidebar">
        <div class="sidebar-logo brand-font d-flex align-items-center gap-2 mb-4">
            <i data-lucide="activity"></i>
            <span>CareConnect</span>
        </div>

        <div class="px-3 mb-4 pb-4 border-bottom border-light">
            <div class="dropdown">
                <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle px-2"
                    id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="bg-dark rounded-circle d-flex align-items-center justify-content-center me-2"
                        style="width: 32px; height: 32px;">
                        <i data-lucide="user" class="text-white" style="width: 18px; height: 18px;"></i>
                    </div>
                    <strong class="small">Administrator</strong>
                </a>
                <ul class="dropdown-menu dropdown-menu-dark shadow border-0 small" aria-labelledby="dropdownUser1">
                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/auth/logout">
                            <i data-lucide="log-out" class="me-2" style="width: 14px; height: 14px;"></i>
                            Sign out
                        </a></li>
                </ul>
            </div>
        </div>

        <nav class="flex-grow-1">
            <ul class="nav flex-column gap-1">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                        class="nav-link <% if(request.getRequestURI().contains(" dashboard.jsp")) { %>active<% } %>">
                            <i data-lucide="layout-dashboard"></i>
                            <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/manage_doctors.jsp"
                        class="nav-link <% if(request.getRequestURI().contains(" manage_doctors.jsp")) { %>active<% } %>
                            ">
                            <i data-lucide="user-cog"></i>
                            <span>Manage Doctors</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/manage_patients.jsp"
                        class="nav-link <% if(request.getRequestURI().contains(" manage_patients.jsp")) { %>active<% }
                            %>">
                            <i data-lucide="users"></i>
                            <span>Manage Patients</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/assign_appointment.jsp"
                        class="nav-link <% if(request.getRequestURI().contains(" assign_appointment.jsp")) { %>active<%
                            } %>">
                            <i data-lucide="calendar-plus"></i>
                            <span>Assign Appointment</span>
                    </a>
                </li>
            </ul>
        </nav>

    </div>
    <script>
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    </script>