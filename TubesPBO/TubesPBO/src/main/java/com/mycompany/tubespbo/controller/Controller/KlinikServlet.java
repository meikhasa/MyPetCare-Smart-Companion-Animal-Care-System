/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.tubespbo.controller.Controller;

/**
 *
 * @author achma
 */

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/klinik")
public class KlinikServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/Klinik/map.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String action = request.getParameter("action");

        // ===== HALAMAN BOOKING =====
        if ("booking".equals(action)) {

            List<Map<String, Object>> pets = new ArrayList<>();

            try (Connection conn = DB.getConnection()) {

                PreparedStatement ps = conn.prepareStatement(
                    "SELECT id, nama FROM pets WHERE user_id = ?"
                );
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Map<String, Object> pet = new HashMap<>();
                    pet.put("id", rs.getInt("id"));
                    pet.put("nama", rs.getString("nama"));
                    pets.add(pet);
                }

            } catch (Exception e) {
                throw new ServletException(e);
            }

            request.setAttribute("pets", pets);
            request.getRequestDispatcher("/Klinik/booking.jsp")
                   .forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard-owner");
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

        int klinikId = Integer.parseInt(request.getParameter("klinik_id"));
        int petId = Integer.parseInt(request.getParameter("pet_id"));
        String tanggal = request.getParameter("tanggal");

        try (Connection conn = DB.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO booking (user_id, pet_id, klinik_id, tanggal, status) " +
                "VALUES (?, ?, ?, ?, 'AKTIF')"
            );
            ps.setInt(1, userId);
            ps.setInt(2, petId);
            ps.setInt(3, klinikId);
            ps.setString(4, tanggal);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new ServletException(e);
        }

        response.sendRedirect(request.getContextPath() + "/dashboard-owner");
    }
}
