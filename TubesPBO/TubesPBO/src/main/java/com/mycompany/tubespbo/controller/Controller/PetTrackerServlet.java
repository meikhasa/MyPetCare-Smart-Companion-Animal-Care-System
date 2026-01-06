package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/pet/tracker")
public class PetTrackerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String petIdParam = request.getParameter("pet_id");
        String action = request.getParameter("action");

        // --- FITUR HAPUS DATA ---
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            try (Connection conn = DB.getConnection()) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM pet_growth WHERE id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
            } catch (Exception e) {
                throw new ServletException(e);
            }
            response.sendRedirect(request.getContextPath() + "/pet/tracker?pet_id=" + petIdParam);
            return;
        }

        if (petIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/pet");
            return;
        }

        int petId = Integer.parseInt(petIdParam);
        Map<String, Object> pet = new HashMap<>();
        List<Map<String, Object>> growthData = new ArrayList<>();

        try (Connection conn = DB.getConnection()) {
            // Ambil Nama Hewan
            PreparedStatement psPet = conn.prepareStatement("SELECT nama FROM pets WHERE id = ?");
            psPet.setInt(1, petId);
            ResultSet rsPet = psPet.executeQuery();
            if (rsPet.next()) {
                pet.put("nama", rsPet.getString("nama"));
            }

            // Ambil Riwayat Pertumbuhan
            PreparedStatement psG = conn.prepareStatement(
                    "SELECT id, tanggal, berat, tinggi, catatan FROM pet_growth WHERE pet_id = ? ORDER BY tanggal ASC"
            );
            psG.setInt(1, petId);
            ResultSet rsG = psG.executeQuery();
            while (rsG.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rsG.getInt("id"));
                row.put("tanggal", rsG.getString("tanggal"));
                row.put("berat", rsG.getDouble("berat"));
                row.put("tinggi", rsG.getDouble("tinggi"));
                row.put("catatan", rsG.getString("catatan"));
                growthData.add(row);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.setAttribute("pet", pet);
        request.setAttribute("pet_id", petId);
        request.setAttribute("growthData", growthData);
        request.getRequestDispatcher("/pet/tracker.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int petId = Integer.parseInt(request.getParameter("pet_id"));
        String tanggal = request.getParameter("tanggal");
        double berat = Double.parseDouble(request.getParameter("berat"));
        double tinggi = Double.parseDouble(request.getParameter("tinggi"));
        String catatan = request.getParameter("catatan");

        try (Connection conn = DB.getConnection()) {
            if ("update".equals(action)) {
                // --- FITUR UPDATE DATA ---
                int id = Integer.parseInt(request.getParameter("id"));
                String sql = "UPDATE pet_growth SET tanggal=?, berat=?, tinggi=?, catatan=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, tanggal);
                ps.setDouble(2, berat);
                ps.setDouble(3, tinggi);
                ps.setString(4, catatan);
                ps.setInt(5, id);
                ps.executeUpdate();
            } else {
                // --- FITUR TAMBAH DATA ---
                String sql = "INSERT INTO pet_growth (pet_id, tanggal, berat, tinggi, catatan) VALUES (?,?,?,?,?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, petId);
                ps.setString(2, tanggal);
                ps.setDouble(3, berat);
                ps.setDouble(4, tinggi);
                ps.setString(5, catatan);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

        response.sendRedirect(request.getContextPath() + "/pet/tracker?pet_id=" + petId);
    }
}
