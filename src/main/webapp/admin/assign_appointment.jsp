<%@ page import="com.careconnect.model.*" %>
    <%@ page import="com.careconnect.dao.HospitalDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } HospitalDAO
                    hospitalDAO=new HospitalDAO(); List<User> doctors = hospitalDAO.getAllDoctors();
                    List<Patient> patients = hospitalDAO.getAllPatients();
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <title>Assign Appointment</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                        </head>

                        <body>
                            <div class="d-flex">
                                <%@ include file="sidebar.jsp" %>

                                    <div class="flex-grow-1 p-4" style="margin-left: 280px;">
                                        <h3>Assign Appointment</h3>

                                        <% if (request.getParameter("success") !=null) { %>
                                            <div class="alert alert-success">
                                                <%= request.getParameter("success") %>
                                            </div>
                                            <% } %>

                                                <div class="card mt-4" style="max-width: 600px;">
                                                    <div class="card-body">
                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/assignAppointment"
                                                            method="POST">
                                                            <div class="mb-3">
                                                                <label class="form-label">Select Patient</label>
                                                                <select name="patientId" class="form-select" required>
                                                                    <option value="">Choose Patient...</option>
                                                                    <% for(Patient p : patients) { %>
                                                                        <option value="<%= p.getId() %>">
                                                                            <%= p.getFullName() %> (<%= p.getEmail() %>)
                                                                        </option>
                                                                        <% } %>
                                                                </select>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label">Assign Doctor</label>
                                                                <select name="doctorId" class="form-select" required>
                                                                    <option value="">Choose Doctor...</option>
                                                                    <% for(User d : doctors) { %>
                                                                        <option value="<%= d.getId() %>">Dr. <%=
                                                                                d.getFullName() %> - <%=
                                                                                    d.getSpecialization() %>
                                                                        </option>
                                                                        <% } %>
                                                                </select>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label">Date</label>
                                                                <input type="date" name="appointmentDate"
                                                                    class="form-control" required>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label">Time Slot</label>
                                                                <select name="appointmentTime" class="form-select"
                                                                    required>
                                                                    <option value="09:00:00">09:00 AM</option>
                                                                    <option value="09:30:00">09:30 AM</option>
                                                                    <option value="10:00:00">10:00 AM</option>
                                                                    <option value="10:30:00">10:30 AM</option>
                                                                    <option value="11:00:00">11:00 AM</option>
                                                                    <option value="11:30:00">11:30 AM</option>
                                                                    <option value="12:00:00">12:00 PM</option>
                                                                    <option value="13:00:00">01:00 PM</option>
                                                                    <option value="13:30:00">01:30 PM</option>
                                                                    <option value="14:00:00">02:00 PM</option>
                                                                    <option value="14:30:00">02:30 PM</option>
                                                                    <option value="15:00:00">03:00 PM</option>
                                                                    <option value="15:30:00">03:30 PM</option>
                                                                    <option value="16:00:00">04:00 PM</option>
                                                                    <option value="16:30:00">04:30 PM</option>
                                                                    <option value="17:00:00">05:00 PM</option>
                                                                </select>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label">Notes</label>
                                                                <textarea name="adminNotes" class="form-control"
                                                                    rows="3"></textarea>
                                                            </div>

                                                            <button type="submit" class="btn btn-primary w-100">Schedule
                                                                Appointment</button>
                                                        </form>
                                                    </div>
                                                </div>
                                    </div>
                            </div>
                        </body>

                        </html>