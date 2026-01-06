package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/belanja")
public class BelanjaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek Session User
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Map<String, Object>> listProduk = new ArrayList<>();
        String kategori = request.getParameter("cat");

        try (Connection conn = DB.getConnection()) {
            // 2. Query Dinamis berdasarkan kategori
            String sql = "SELECT * FROM produk";
            if (kategori != null && !kategori.equals("Semua")) {
                sql += " WHERE kategori = ?";
            }

            PreparedStatement ps = conn.prepareStatement(sql);
            if (kategori != null && !kategori.equals("Semua")) {
                ps.setString(1, kategori);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> p = new HashMap<>();
                p.put("id", rs.getInt("id"));
                p.put("nama", rs.getString("nama"));
                p.put("kategori", rs.getString("kategori"));
                p.put("harga", rs.getDouble("harga"));
                p.put("stok", rs.getInt("stok"));
                p.put("gambar", rs.getString("gambar"));
                listProduk.add(p);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

        // 3. Kirim data ke JSP (Karena JSP ada di folder pet, sertakan jalurnya)
        request.setAttribute("listProduk", listProduk);
        request.setAttribute("catAktif", (kategori == null) ? "Semua" : kategori);
        request.getRequestDispatcher("/pet/belanja.jsp").forward(request, response);
    }
}