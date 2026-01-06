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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try (Connection conn = DB.getConnection()) {

            if (action == null || action.equals("list")) {
                // LIST USER
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM users");
                ResultSet rs = ps.executeQuery();
                req.setAttribute("users", rs);
                req.getRequestDispatcher("user/list.jsp").forward(req, resp);

            } else if (action.equals("add")) {
                req.getRequestDispatcher("user/add.jsp").forward(req, resp);

            } else if (action.equals("edit")) {
                int id = Integer.parseInt(req.getParameter("id"));
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id=?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    req.setAttribute("user", rs);
                    req.getRequestDispatcher("user/edit.jsp").forward(req, resp);
                }

            } else if (action.equals("delete")) {
                int id = Integer.parseInt(req.getParameter("id"));
                PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id=?");
                ps.setInt(1, id);
                ps.executeUpdate();
                resp.sendRedirect("user?action=list");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try (Connection conn = DB.getConnection()) {

            if (action.equals("insert")) {
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO users(username, password, role) VALUES(?,?,?)");

                ps.setString(1, req.getParameter("username"));
                ps.setString(2, req.getParameter("password"));
                ps.setString(3, req.getParameter("role"));
                ps.executeUpdate();
                resp.sendRedirect("user?action=list");

            } else if (action.equals("update")) {
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE users SET username=?, password=?, role=? WHERE id=?");

                ps.setString(1, req.getParameter("username"));
                ps.setString(2, req.getParameter("password"));
                ps.setString(3, req.getParameter("role"));
                ps.setInt(4, Integer.parseInt(req.getParameter("id")));
                ps.executeUpdate();
                resp.sendRedirect("user?action=list");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
