//
//import com.mycompany.tubespbo.controller.helper.DB;
//import java.io.IOException;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.Statement;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//@WebServlet("/register")
//
//public class RegisterServlet extends HttpServlet {
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//        String role = request.getParameter("role");
//
//        try (Connection conn = DB.getConnection()) {
//
//            String sql = "INSERT INTO users (username, password, role) VALUES (?,?,?)";
//            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
//            ps.setString(1, username);
//            ps.setString(2, password);
//            ps.setString(3, role);
//            ps.executeUpdate();
//
//            // ambil ID user
//            ResultSet rs = ps.getGeneratedKeys();
//            int userId = 0;
//            if (rs.next()) userId = rs.getInt(1);
//
//            // SIMPAN SESSION
//            HttpSession session = request.getSession();
//            session.setAttribute("user_id", userId);
//            session.setAttribute("username", username);
//            session.setAttribute("role", role);
//
//            // REDIRECT
//            if ("owner".equals(role)) {
//                response.sendRedirect(request.getContextPath() + "/pet");
//            } else {
//                response.sendRedirect(request.getContextPath() + "/dashboard-vet.jsp");
//            }
//
//        } catch (Exception e) {
//            throw new ServletException(e);
//        }
//    }
//}

package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection conn = DB.getConnection()) {
            // Query untuk memasukkan data user baru
            String sql = "INSERT INTO users (username, password, role) VALUES (?,?,?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, role);
                
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    // ALUR DIPERBAIKI: Redirect ke login.jsp dengan parameter sukses
                    response.sendRedirect(request.getContextPath() + "/login.jsp?status=success");
                } else {
                    // Jika gagal simpan, kembali ke register
                    response.sendRedirect(request.getContextPath() + "/register.jsp?error=failed");
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}