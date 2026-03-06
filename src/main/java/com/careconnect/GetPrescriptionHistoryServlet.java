package com.careconnect;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.careconnect.Entities.*;

@WebServlet("/doctor/getPrescriptionHistory")
public class GetPrescriptionHistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            int apptId = Integer.parseInt(request.getParameter("appointmentId"));
            HospitalDAO dao = new HospitalDAO();

            List<Prescription> prescriptions = dao.getPrescriptionsByAppointment(apptId);

            if (prescriptions == null || prescriptions.isEmpty()) {
                out.println("<div class='alert alert-info'>No prescription found for this appointment.</div>");
                return;
            }

            for (Prescription p : prescriptions) {
                out.println("<div class='mb-4 pb-3 border-bottom'>");
                out.println(
                        "  <div class='mb-2'><span class='badge bg-light text-dark fw-bold'>Diagnosis</span></div>");
                out.println("  <p class='text-dark'>" + p.getDiagnosis() + "</p>");

                List<PrescriptionDetail> details = dao.getPrescriptionDetails(p.getId());
                if (!details.isEmpty()) {
                    out.println("  <div class='table-responsive'>");
                    out.println("    <table class='table table-sm table-borderless align-middle mt-2'>");
                    out.println("      <thead class='bg-light'>");
                    out.println("        <tr class='text-secondary' style='font-size: 0.75rem'>");
                    out.println("          <th class='ps-2'>Medicine</th>");
                    out.println("          <th>Dosage (M-N-E-Nt)</th>");
                    out.println("          <th>Duration</th>");
                    out.println("          <th class='text-center'>Qty</th>");
                    out.println("        </tr>");
                    out.println("      </thead>");
                    out.println("      <tbody>");
                    for (PrescriptionDetail d : details) {
                        out.println("        <tr>");
                        out.println("          <td class='ps-2 fw-medium'>" + d.getMedicineName() + "</td>");
                        out.println("          <td>" + d.getDosageMorning() + "-" + d.getDosageNoon() + "-"
                                + d.getDosageEvening() + "-" + d.getDosageNight() + "</td>");
                        out.println("          <td>" + d.getDuration() + "</td>");
                        out.println("          <td class='text-center'>" + d.getQuantity() + "</td>");
                        out.println("        </tr>");
                    }
                    out.println("      </tbody>");
                    out.println("    </table>");
                    out.println("  </div>");
                }
                out.println("</div>");
            }
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger'>Invalid appointment ID provided.</div>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger'>An error occurred while fetching prescription details.</div>");
        }
    }
}
