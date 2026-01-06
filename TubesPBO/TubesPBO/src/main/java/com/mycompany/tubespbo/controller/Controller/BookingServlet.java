package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String action = request.getParameter("action");

        // --- 1. TAMPILAN MAP (DAFTAR KLINIK) ---
        // Perbaikan: Menangani jika action null ATAU action bermuatan "map"
        if (action == null || "map".equals(action)) {
            List<Map<String, Object>> clinics = new ArrayList<>();
            try (Connection conn = DB.getConnection()) {
                PreparedStatement ps = conn.prepareStatement("SELECT id, nama, alamat, latitude, longitude FROM clinics");
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> c = new HashMap<>();
                    c.put("id", rs.getInt("id"));
                    c.put("nama", rs.getString("nama"));
                    c.put("alamat", rs.getString("alamat"));
                    c.put("latitude", rs.getDouble("latitude"));
                    c.put("longitude", rs.getDouble("longitude"));
                    clinics.add(c);
                }
            } catch (Exception e) {
                throw new ServletException(e);
            }
            request.setAttribute("clinics", clinics);
            request.getRequestDispatcher("/Klinik/map.jsp").forward(request, response);
            return;
        }

        // --- 2. TAMPILAN FORM BOOKING (Pilih Klinik -> Form) ---
        if ("form".equals(action)) {
            String klinikIdStr = request.getParameter("klinik_id");
            if (klinikIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }

            int klinikId = Integer.parseInt(klinikIdStr);
            Map<String, Object> klinik = new HashMap<>();
            List<Map<String, Object>> pets = new ArrayList<>();

            try (Connection conn = DB.getConnection()) {
                // Ambil data klinik spesifik
                PreparedStatement psK = conn.prepareStatement("SELECT id, nama FROM clinics WHERE id = ?");
                psK.setInt(1, klinikId);
                ResultSet rsK = psK.executeQuery();
                if (rsK.next()) {
                    klinik.put("id", rsK.getInt("id"));
                    klinik.put("nama", rsK.getString("nama"));
                }

                // Ambil data pets milik user
                PreparedStatement psP = conn.prepareStatement("SELECT id, nama, jenis FROM pets WHERE user_id = ?");
                psP.setInt(1, userId);
                ResultSet rsP = psP.executeQuery();
                while (rsP.next()) {
                    Map<String, Object> p = new HashMap<>();
                    p.put("id", rsP.getInt("id"));
                    p.put("nama", rsP.getString("nama"));
                    p.put("jenis", rsP.getString("jenis"));
                    pets.add(p);
                }
            } catch (Exception e) {
                throw new ServletException(e);
            }

            request.setAttribute("klinik", klinik);
            request.setAttribute("pets", pets);
            request.getRequestDispatcher("/Klinik/booking.jsp").forward(request, response);
            return;
        }

        // --- 3. LOGIKA UPDATE & DELETE (Reminder) ---
        if ("updateStatus".equals(action) || "delete".equals(action)) {
            handleUpdates(request, userId, action);
            response.sendRedirect(request.getContextPath() + "/booking?action=reminder");
            return;
        }

        // --- 4. TAMPILAN REMINDER ---
        if ("reminder".equals(action)) {
            showReminder(request, response, userId);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        try {
            int petId = Integer.parseInt(request.getParameter("pet_id"));
            int klinikId = Integer.parseInt(request.getParameter("klinik_id"));
            String tanggal = request.getParameter("tanggal");
            String keperluan = request.getParameter("keperluan");

            try (Connection conn = DB.getConnection()) {
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO booking (user_id, pet_id, klinik_id, tanggal, keperluan, status) VALUES (?, ?, ?, ?, ?, 'AKTIF')"
                );
                ps.setInt(1, userId);
                ps.setInt(2, petId);
                ps.setInt(3, klinikId);
                ps.setString(4, tanggal);
                ps.setString(5, keperluan);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

        response.sendRedirect(request.getContextPath() + "/booking?action=reminder");
    }

    private void handleUpdates(HttpServletRequest request, int userId, String action) throws ServletException {
        String id = request.getParameter("id");
        if (id == null) {
            return;
        }

        try (Connection conn = DB.getConnection()) {
            if ("updateStatus".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("UPDATE booking SET status = ? WHERE id = ? AND user_id = ?");
                ps.setString(1, request.getParameter("status"));
                ps.setInt(2, Integer.parseInt(id));
                ps.setInt(3, userId);
                ps.executeUpdate();
            } else if ("delete".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM booking WHERE id = ? AND user_id = ?");
                ps.setInt(1, Integer.parseInt(id));
                ps.setInt(2, userId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void showReminder(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        Map<String, Object> booking = new HashMap<>();
        try (Connection conn = DB.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT b.id, b.tanggal, b.status, b.keperluan, c.nama AS nama_klinik, p.nama AS nama_pet "
                    + "FROM booking b JOIN clinics c ON b.klinik_id = c.id JOIN pets p ON b.pet_id = p.id "
                    + "WHERE b.user_id = ? ORDER BY b.id DESC LIMIT 1"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                booking.put("id", rs.getInt("id"));
                booking.put("tanggal", rs.getString("tanggal"));
                booking.put("status", rs.getString("status"));
                booking.put("klinik", rs.getString("nama_klinik"));
                booking.put("pet", rs.getString("nama_pet"));
                booking.put("keperluan", rs.getString("keperluan"));
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/Klinik/reminder.jsp").forward(request, response);
    }
}
