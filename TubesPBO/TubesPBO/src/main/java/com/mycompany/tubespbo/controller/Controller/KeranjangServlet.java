package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/keranjang")
public class KeranjangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");

        // --- LOGIKA TAMBAH PRODUK (Disederhanakan untuk mencegah loading lama) ---
        if ("add".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int produkId = Integer.parseInt(idStr);
                // Gunakan try-with-resources agar koneksi otomatis tertutup
                try (Connection conn = DB.getConnection()) {
                    conn.setAutoCommit(false);
                    try {
                        // 1. Cek stok produk terlebih dahulu
                        String sqlStok = "SELECT stok FROM produk WHERE id = ?";
                        PreparedStatement psStok = conn.prepareStatement(sqlStok);
                        psStok.setInt(1, produkId);
                        ResultSet rsStok = psStok.executeQuery();

                        if (rsStok.next() && rsStok.getInt("stok") > 0) {
                            // 2. Gunakan ON DUPLICATE KEY UPDATE agar query lebih cepat (Hanya jika DB mendukung)
                            // Jika tidak, gunakan logika cek manual yang sudah Anda buat
                            String sqlCek = "SELECT id FROM keranjang WHERE user_id = ? AND produk_id = ?";
                            PreparedStatement psCek = conn.prepareStatement(sqlCek);
                            psCek.setInt(1, userId);
                            psCek.setInt(2, produkId);
                            ResultSet rsCek = psCek.executeQuery();

                            if (rsCek.next()) {
                                PreparedStatement psUp = conn.prepareStatement("UPDATE keranjang SET qty = qty + 1 WHERE id = ?");
                                psUp.setInt(1, rsCek.getInt("id"));
                                psUp.executeUpdate();
                            } else {
                                PreparedStatement psIns = conn.prepareStatement("INSERT INTO keranjang (user_id, produk_id, qty) VALUES (?, ?, 1)");
                                psIns.setInt(1, userId);
                                psIns.setInt(2, produkId);
                                psIns.executeUpdate();
                            }

                            // 3. Kurangi stok produk
                            PreparedStatement psMin = conn.prepareStatement("UPDATE produk SET stok = stok - 1 WHERE id = ?");
                            psMin.setInt(1, produkId);
                            psMin.executeUpdate();
                            
                            conn.commit();
                        }
                    } catch (Exception e) {
                        conn.rollback(); // PENTING: Melepaskan kunci jika gagal agar tidak loading lama
                        e.printStackTrace();
                    }
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect(request.getContextPath() + "/keranjang");
            return;
        }

        // --- LOGIKA TAMPILKAN DATA (Optimasi Query) ---
        List<Map<String, Object>> items = new ArrayList<>();
        double total = 0;

        try (Connection conn = DB.getConnection()) {
            String sql = "SELECT k.id, p.nama, p.kategori, p.harga, p.gambar, k.qty " +
                         "FROM keranjang k JOIN produk p ON k.produk_id = p.id " +
                         "WHERE k.user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getInt("id"));
                item.put("nama", rs.getString("nama"));
                item.put("kategori", rs.getString("kategori"));
                double harga = rs.getDouble("harga");
                int qty = rs.getInt("qty");
                item.put("harga", harga);
                item.put("gambar", rs.getString("gambar"));
                item.put("qty", qty);
                items.add(item);
                total += (harga * qty); // Menghitung total langsung di Java lebih cepat daripada query ulang
            }
        } catch (Exception e) { throw new ServletException(e); }

        request.setAttribute("items", items);
        request.setAttribute("total", total);
        request.getRequestDispatcher("/pet/keranjang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false);
            try {
                if ("plus".equals(action)) {
                    // Query JOIN untuk efisiensi agar tidak banyak buka-tutup PreparedStatement
                    String sql = "UPDATE keranjang k JOIN produk p ON k.produk_id = p.id " +
                                 "SET k.qty = k.qty + 1, p.stok = p.stok - 1 " +
                                 "WHERE k.id = ? AND p.stok > 0";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, id);
                    ps.executeUpdate();
                } else if ("minus".equals(action)) {
                    // Ambil qty dan produk_id
                    PreparedStatement ps = conn.prepareStatement("SELECT qty, produk_id FROM keranjang WHERE id = ?");
                    ps.setInt(1, id);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        int qty = rs.getInt("qty");
                        int pId = rs.getInt("produk_id");
                        if (qty > 1) {
                            PreparedStatement psUp = conn.prepareStatement("UPDATE keranjang SET qty = qty - 1 WHERE id = ?");
                            psUp.setInt(1, id);
                            psUp.executeUpdate();
                        } else {
                            PreparedStatement psDel = conn.prepareStatement("DELETE FROM keranjang WHERE id = ?");
                            psDel.setInt(1, id);
                            psDel.executeUpdate();
                        }
                        PreparedStatement psStok = conn.prepareStatement("UPDATE produk SET stok = stok + 1 WHERE id = ?");
                        psStok.setInt(1, pId);
                        psStok.executeUpdate();
                    }
                }
                conn.commit();
            } catch (Exception e) {
                conn.rollback(); // Mencegah database terkunci
                e.printStackTrace();
            }
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/keranjang");
    }
}