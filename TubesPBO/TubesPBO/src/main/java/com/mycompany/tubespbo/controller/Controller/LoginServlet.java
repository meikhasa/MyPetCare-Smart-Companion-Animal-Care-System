    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
     */
   package com.mycompany.tubespbo.controller.Controller;

import com.mycompany.tubespbo.controller.helper.DB;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DB.getConnection()) {

            if (conn == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=db");
                return;
            }

            String sql = "SELECT id, username, role FROM users WHERE username=? AND password=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // SIMPAN SESSION
                        HttpSession session = request.getSession(true);
                        session.setAttribute("user_id", rs.getInt("id"));
                        session.setAttribute("username", rs.getString("username"));
                        session.setAttribute("role", rs.getString("role"));
                       
                        
                        String role = rs.getString("role");
                        
                        // ===== REDIRECT SESUAI ROLE =====
                        if ("admin".equalsIgnoreCase(role)) {
                            response.sendRedirect(request.getContextPath() + "/dashboard-admin.jsp");
                            
                        } else if ("vet".equalsIgnoreCase(role)) {
                            response.sendRedirect(request.getContextPath() + "/dashboard-vet.jsp");
                            
                        } else if ("owner".equalsIgnoreCase(role)) {
                            response.sendRedirect(request.getContextPath() + "/dashboard-owner");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/login.jsp?error=role");
                        }
                        
                    } else {
                        response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                    }
                }
            }

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=exception");
        }
    }
}