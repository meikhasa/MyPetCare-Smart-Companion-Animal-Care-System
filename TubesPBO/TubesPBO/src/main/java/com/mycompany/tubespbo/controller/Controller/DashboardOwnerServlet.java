package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/dashboard-owner")
public class DashboardOwnerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Mencegah Browser menyimpan Cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        List<Map<String, Object>> pets = new ArrayList<>();
        List<Map<String, Object>> bookings = new ArrayList<>();
        int totalPets = 0;
        int totalBooking = 0;
        int totalGrowthLogs = 0;
        int totalKeranjang = 0;

        try (Connection conn = DB.getConnection()) {

            // ===== QUERY 1: LIST HEWAN TERBARU (DITAMBAHKAN KOLOM FOTO) =====
            // PENTING: Menambahkan kolom 'foto' agar tidak tertukar di JSP
            String sqlPets = "SELECT id, nama, jenis, usia, foto FROM pets WHERE user_id = ? LIMIT 5";
            try (PreparedStatement ps = conn.prepareStatement(sqlPets)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> p = new HashMap<>();
                        p.put("id", rs.getInt("id"));
                        p.put("nama", rs.getString("nama"));
                        p.put("jenis", rs.getString("jenis"));
                        p.put("usia", rs.getInt("usia"));
                        p.put("foto", rs.getString("foto")); // Mengambil foto unik tiap hewan
                        pets.add(p);
                    }
                }
            }

            // ===== QUERY 2: HITUNG TOTAL HEWAN =====
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM pets WHERE user_id = ?")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalPets = rs.getInt(1);
                    }
                }
            }

            // ===== QUERY 3: HITUNG TOTAL BOOKING AKTIF =====
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM booking WHERE user_id = ?")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalBooking = rs.getInt(1);
                    }
                }
            }

            // ===== QUERY 4: HITUNG TOTAL LOG PERTUMBUHAN =====
            String sqlGrowth = "SELECT COUNT(*) FROM pet_growth g JOIN pets p ON g.pet_id = p.id WHERE p.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlGrowth)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalGrowthLogs = rs.getInt(1);
                    }
                }
            }

            // ===== QUERY 5: HITUNG ITEM KERANJANG (MENGGUNAKAN KOLOM QTY) =====
            // Menggunakan SUM(qty) agar jumlah barang akurat, bukan cuma jumlah baris
            try (PreparedStatement ps = conn.prepareStatement("SELECT SUM(qty) FROM keranjang WHERE user_id = ?")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalKeranjang = rs.getInt(1);
                    }
                }
            } catch (Exception e) {
                totalKeranjang = 0;
            }

            // ===== QUERY 6: AMBIL DATA BOOKING TERBARU =====
            String sqlRecentBookings = "SELECT b.tanggal, c.nama as klinik, p.nama as pet, b.keperluan "
                    + "FROM booking b "
                    + "JOIN clinics c ON b.klinik_id = c.id "
                    + "JOIN pets p ON b.pet_id = p.id "
                    + "WHERE b.user_id = ? ORDER BY b.id DESC LIMIT 3";
            try (PreparedStatement ps = conn.prepareStatement(sqlRecentBookings)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> b = new HashMap<>();
                        b.put("tanggal", rs.getString("tanggal"));
                        b.put("klinik", rs.getString("klinik"));
                        b.put("pet", rs.getString("pet"));
                        b.put("layanan", rs.getString("keperluan"));
                        bookings.add(b);
                    }
                }
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.setAttribute("pets", pets);
        request.setAttribute("bookings", bookings);
        request.setAttribute("totalPets", totalPets);
        request.setAttribute("totalBooking", totalBooking);
        request.setAttribute("totalGrowthLogs", totalGrowthLogs);
        request.setAttribute("totalKeranjang", totalKeranjang);

        request.getRequestDispatcher("/dashboard-owner.jsp").forward(request, response);
    }
}
