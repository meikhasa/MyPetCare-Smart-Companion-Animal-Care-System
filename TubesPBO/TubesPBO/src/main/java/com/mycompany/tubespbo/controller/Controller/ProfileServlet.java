package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        Map<String, Object> userData = new HashMap<>();
        List<Map<String, Object>> riwayatBelanja = new ArrayList<>(); // Tambahan untuk riwayat

        try (Connection conn = DB.getConnection()) {
            // 1. Ambil Data User
            String sql = "SELECT username, display_name, role, gender, profile_pic, created_at FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                userData.put("username", rs.getString("username"));
                userData.put("display_name", rs.getString("display_name"));
                userData.put("role", rs.getString("role"));
                userData.put("gender", rs.getString("gender"));
                userData.put("profile_pic", rs.getString("profile_pic"));
                userData.put("created_at", rs.getTimestamp("created_at"));
            }

            // 2. TAMBAHAN: Ambil Riwayat Belanja dari history_transaksi
            String sqlRiwayat = "SELECT h.qty, h.total_harga, h.tanggal_transaksi, p.nama, p.gambar "
                    + "FROM history_transaksi h "
                    + "JOIN produk p ON h.produk_id = p.id "
                    + "WHERE h.user_id = ? "
                    + "ORDER BY h.tanggal_transaksi DESC";
            PreparedStatement psR = conn.prepareStatement(sqlRiwayat);
            psR.setInt(1, userId);
            ResultSet rsR = psR.executeQuery();

            while (rsR.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("nama", rsR.getString("nama"));
                item.put("gambar", rsR.getString("gambar"));
                item.put("qty", rsR.getInt("qty"));
                item.put("total", rsR.getDouble("total_harga"));
                item.put("tanggal", rsR.getTimestamp("tanggal_transaksi"));
                riwayatBelanja.add(item);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.setAttribute("userData", userData);
        request.setAttribute("riwayat", riwayatBelanja); // Kirim list riwayat ke JSP
        request.getRequestDispatcher("/pet/profile-owner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("user_id");

        String displayName = request.getParameter("display_name");
        String gender = request.getParameter("gender");

        Part filePart = request.getPart("profile_pic");
        String fileName = request.getParameter("existing_pic");

        if (filePart != null && filePart.getSize() > 0) {
            fileName = "user_" + userId + "_" + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("/") + "img";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            filePart.write(uploadPath + File.separator + fileName);
        }

        try (Connection conn = DB.getConnection()) {
            String sql = "UPDATE users SET display_name = ?, gender = ?, profile_pic = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, displayName);
            ps.setString(2, gender);
            ps.setString(3, fileName);
            ps.setInt(4, userId);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/profile");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
