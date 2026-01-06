package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false); // Memulai transaksi
            try {
                // 1. Pindahkan data dari keranjang ke history_transaksi
                String sqlHistory = "INSERT INTO history_transaksi (user_id, produk_id, qty, total_harga) "
                        + "SELECT k.user_id, k.produk_id, k.qty, (p.harga * k.qty) "
                        + "FROM keranjang k JOIN produk p ON k.produk_id = p.id "
                        + "WHERE k.user_id = ?";
                PreparedStatement psHist = conn.prepareStatement(sqlHistory);
                psHist.setInt(1, userId);
                psHist.executeUpdate();

                // 2. Kosongkan keranjang user setelah dipindah ke history
                String sqlDelete = "DELETE FROM keranjang WHERE user_id = ?";
                PreparedStatement psDel = conn.prepareStatement(sqlDelete);
                psDel.setInt(1, userId);
                psDel.executeUpdate();

                conn.commit(); // Simpan semua perubahan

                // Kirim ke halaman sukses
                request.getRequestDispatcher("/pet/checkout-sukses.jsp").forward(request, response);

            } catch (Exception e) {
                conn.rollback(); // Batalkan jika ada yang gagal
                e.printStackTrace();
                response.getWriter().println("Terjadi kesalahan saat checkout: " + e.getMessage());
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
