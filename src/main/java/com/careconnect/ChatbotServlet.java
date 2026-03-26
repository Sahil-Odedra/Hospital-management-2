package com.careconnect;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@WebServlet("/api/chatbot")
public class ChatbotServlet extends HttpServlet {

    private static final String EXTERNAL_CHATBOT_API = "https://rag-chatbot-733796290876.asia-southeast1.run.app/api/chat";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Read JSON request from frontend
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            // Parse incoming JSON to ensure it's valid
            JsonObject jsonRequest = JsonParser.parseString(sb.toString()).getAsJsonObject();

            // Prepare HTTP connection to external API
            URL url = new URL(EXTERNAL_CHATBOT_API);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // Send payload to Cloud Run API
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonRequest.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // Read Response from external API
            int status = conn.getResponseCode();
            BufferedReader inReader;
            if (status >= 200 && status < 300) {
                inReader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            } else {
                inReader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            }

            StringBuilder responseBuilder = new StringBuilder();
            String responseLine;
            while ((responseLine = inReader.readLine()) != null) {
                responseBuilder.append(responseLine.trim());
            }
            inReader.close();

            // Forward exact response downstream
            response.setStatus(status);
            response.getWriter().write(responseBuilder.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorObj = new JsonObject();
            errorObj.addProperty("error", "Internal Server Error during Chatbot API invocation");
            errorObj.addProperty("details", e.getMessage());
            response.getWriter().write(errorObj.toString());
        }
    }
}
