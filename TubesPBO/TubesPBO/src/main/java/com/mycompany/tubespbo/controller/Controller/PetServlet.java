//package com.mycompany.tubespbo.controller.Controller;
//
//import com.mycompany.tubespbo.controller.helper.DB;
//import java.io.File;
//import java.io.IOException;
//import java.sql.*;
//import java.util.*;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//
//@WebServlet("/pet")
//@MultipartConfig
//public class PetServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user_id") == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
//
//        String action = request.getParameter("action");
//        if (action == null) {
//            action = "list";
//        }
//
//        try {
//            switch (action) {
//                case "add":
//                    request.getRequestDispatcher("/pet/add.jsp").forward(request, response);
//                    break;
//                case "detail": // Menampilkan info lengkap hewan
//                    showDetail(request, response);
//                    break;
//                case "edit": // Menampilkan form untuk edit
//                    showEditForm(request, response);
//                    break;
//                case "delete":
//                    deletePet(request, response);
//                    break;
//                default:
//                    loadHewanSaya(request, response);
//                    break;
//            }
//        } catch (Exception e) {
//            throw new ServletException(e);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//
//        try {
//            if ("update".equals(action)) {
//                updatePet(request);
//                int id = Integer.parseInt(request.getParameter("id"));
//                // Alur: Kembali ke detail setelah edit
//                response.sendRedirect(request.getContextPath() + "/pet?action=detail&id=" + id);
//            } else {
//                insertPet(request);
//                // ALUR PENTING: Redirect ke SERVLET dashboard agar angka total hewan langsung update
//                response.sendRedirect(request.getContextPath() + "/dashboard-owner");
//            }
//        } catch (Exception e) {
//            throw new ServletException(e);
//        }
//    }
//
//    // =========================================================================
//    // FUNGSI AWAL (TIDAK DIHAPUS, HANYA DISINKRONKAN PATHNYA)
//    // =========================================================================
//    private void loadHewanSaya(HttpServletRequest request, HttpServletResponse response)
//            throws Exception {
//        int userId = (int) request.getSession().getAttribute("user_id");
//        List<Map<String, Object>> pets = new ArrayList<>();
//        String sql = "SELECT id, nama, jenis, ras, usia, foto FROM pets WHERE user_id = ?";
//
//        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, userId);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                Map<String, Object> p = new HashMap<>();
//                p.put("id", rs.getInt("id"));
//                p.put("nama", rs.getString("nama"));
//                p.put("jenis", rs.getString("jenis"));
//                p.put("ras", rs.getString("ras"));
//                p.put("usia", rs.getInt("usia"));
//                p.put("foto", rs.getString("foto"));
//                pets.add(p);
//            }
//        }
//        request.setAttribute("pets", pets);
//        request.getRequestDispatcher("/hewan-saya.jsp").forward(request, response);
//    }
//
//    private void insertPet(HttpServletRequest request) throws Exception {
//        int userId = (int) request.getSession().getAttribute("user_id");
//        String nama = request.getParameter("nama");
//        String jenis = request.getParameter("jenis");
//        String ras = request.getParameter("ras");
//        int usia = Integer.parseInt(request.getParameter("usia"));
//        String catatan = request.getParameter("catatan");
//
//        Part fotoPart = request.getPart("foto");
//        String fotoName = System.currentTimeMillis() + "_" + fotoPart.getSubmittedFileName();
//
//        // Path diperbaiki agar browser bisa baca (masuk ke root webapp)
//        String uploadPath = getServletContext().getRealPath("/") + "uploads";
//        File dir = new File(uploadPath);
//        if (!dir.exists()) {
//            dir.mkdirs();
//        }
//
//        fotoPart.write(uploadPath + File.separator + fotoName);
//
//        String sql = "INSERT INTO pets (user_id, nama, jenis, ras, usia, foto, catatan) VALUES (?,?,?,?,?,?,?)";
//        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, userId);
//            ps.setString(2, nama);
//            ps.setString(3, jenis);
//            ps.setString(4, ras);
//            ps.setInt(5, usia);
//            ps.setString(6, fotoName);
//            ps.setString(7, catatan);
//            ps.executeUpdate();
//        }
//    }
//
//    private void deletePet(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        int id = Integer.parseInt(request.getParameter("id"));
//        int userId = (int) request.getSession().getAttribute("user_id");
//        String sql = "DELETE FROM pets WHERE id = ? AND user_id = ?";
//        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            ps.setInt(2, userId);
//            ps.executeUpdate();
//        }
//        // Redirect ke dashboard agar statistik update
//        response.sendRedirect(request.getContextPath() + "/dashboard-owner");
//    }
//
//    // =========================================================================
//    // FUNGSI BARU (DETAIL & EDIT)
//    // =========================================================================
//    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        int id = Integer.parseInt(request.getParameter("id"));
//        int userId = (int) request.getSession().getAttribute("user_id");
//        Map<String, Object> pet = new HashMap<>();
//
//        String sql = "SELECT * FROM pets WHERE id = ? AND user_id = ?";
//        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            ps.setInt(2, userId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                pet.put("id", rs.getInt("id"));
//                pet.put("nama", rs.getString("nama"));
//                pet.put("jenis", rs.getString("jenis"));
//                pet.put("ras", rs.getString("ras"));
//                pet.put("usia", rs.getInt("usia"));
//                pet.put("foto", rs.getString("foto"));
//                pet.put("catatan", rs.getString("catatan"));
//            }
//        }
//        request.setAttribute("pet", pet);
//        request.getRequestDispatcher("/pet/detail.jsp").forward(request, response);
//    }
//
//    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        int id = Integer.parseInt(request.getParameter("id"));
//        int userId = (int) request.getSession().getAttribute("user_id");
//
//        try (Connection conn = DB.getConnection()) {
//            PreparedStatement ps = conn.prepareStatement("SELECT * FROM pets WHERE id = ? AND user_id = ?");
//            ps.setInt(1, id);
//            ps.setInt(2, userId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                request.setAttribute("pet_id", rs.getInt("id"));
//                request.setAttribute("nama", rs.getString("nama"));
//                request.setAttribute("jenis", rs.getString("jenis"));
//                request.setAttribute("ras", rs.getString("ras"));
//                request.setAttribute("usia", rs.getInt("usia"));
//                request.setAttribute("foto", rs.getString("foto"));
//                request.setAttribute("catatan", rs.getString("catatan"));
//            }
//        }
//        request.getRequestDispatcher("/pet/edit.jsp").forward(request, response);
//    }
//
//    private void updatePet(HttpServletRequest request) throws Exception {
//        int id = Integer.parseInt(request.getParameter("id"));
//        String nama = request.getParameter("nama");
//        String jenis = request.getParameter("jenis");
//        String ras = request.getParameter("ras");
//        int usia = Integer.parseInt(request.getParameter("usia"));
//        String catatan = request.getParameter("catatan");
//
//        Part fotoPart = request.getPart("foto");
//        String uploadPath = getServletContext().getRealPath("/") + "uploads";
//        File dir = new File(uploadPath);
//        if (!dir.exists()) {
//            dir.mkdirs();
//        }
//
//        if (fotoPart != null && fotoPart.getSize() > 0) {
//            String fotoName = System.currentTimeMillis() + "_" + fotoPart.getSubmittedFileName();
//            fotoPart.write(uploadPath + File.separator + fotoName);
//
//            String sql = "UPDATE pets SET nama=?, jenis=?, ras=?, usia=?, catatan=?, foto=? WHERE id=?";
//            try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//                ps.setString(1, nama);
//                ps.setString(2, jenis);
//                ps.setString(3, ras);
//                ps.setInt(4, usia);
//                ps.setString(5, catatan);
//                ps.setString(6, fotoName);
//                ps.setInt(7, id);
//                ps.executeUpdate();
//            }
//        } else {
//            String sql = "UPDATE pets SET nama=?, jenis=?, ras=?, usia=?, catatan=? WHERE id=?";
//            try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//                ps.setString(1, nama);
//                ps.setString(2, jenis);
//                ps.setString(3, ras);
//                ps.setInt(4, usia);
//                ps.setString(5, catatan);
//                ps.setInt(6, id);
//                ps.executeUpdate();
//            }
//        }
//    }
//}

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

@WebServlet("/pet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class PetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/pet/add.jsp").forward(request, response);
                    break;
                case "detail":
                    showDetail(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deletePet(request, response);
                    break;
                default:
                    loadHewanSaya(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("update".equals(action)) {
                updatePet(request);
                int id = Integer.parseInt(request.getParameter("id"));
                response.sendRedirect(request.getContextPath() + "/pet?action=detail&id=" + id);
            } else {
                insertPet(request);
                // Redirect ke Dashboard agar statistik angka berubah
                response.sendRedirect(request.getContextPath() + "/dashboard-owner");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void loadHewanSaya(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int userId = (int) request.getSession().getAttribute("user_id");
        List<Map<String, Object>> pets = new ArrayList<>();
        String sql = "SELECT id, nama, jenis, ras, usia, foto FROM pets WHERE user_id = ?";

        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> p = new HashMap<>();
                p.put("id", rs.getInt("id"));
                p.put("nama", rs.getString("nama"));
                p.put("jenis", rs.getString("jenis"));
                p.put("ras", rs.getString("ras"));
                p.put("usia", rs.getInt("usia"));
                p.put("foto", rs.getString("foto"));
                pets.add(p);
            }
        }
        request.setAttribute("pets", pets);
        request.getRequestDispatcher("/hewan-saya.jsp").forward(request, response);
    }

    private void insertPet(HttpServletRequest request) throws Exception {
        int userId = (int) request.getSession().getAttribute("user_id");
        String nama = request.getParameter("nama");
        String jenis = request.getParameter("jenis");
        String ras = request.getParameter("ras");
        int usia = (request.getParameter("usia") != null && !request.getParameter("usia").isEmpty()) 
                   ? Integer.parseInt(request.getParameter("usia")) : 0;
        String catatan = request.getParameter("catatan");

        // PROSES UPLOAD OTOMATIS
        Part fotoPart = request.getPart("foto");
        String fileName = "default-pet.jpg"; // Default jika tidak ada upload

        if (fotoPart != null && fotoPart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + fotoPart.getSubmittedFileName();
            // Simpan ke folder 'img' (Web Pages/img)
            String uploadPath = getServletContext().getRealPath("/") + "img";
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();
            
            fotoPart.write(uploadPath + File.separator + fileName);
        }

        String sql = "INSERT INTO pets (user_id, nama, jenis, ras, usia, foto, catatan) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, nama);
            ps.setString(3, jenis);
            ps.setString(4, ras);
            ps.setInt(5, usia);
            ps.setString(6, fileName);
            ps.setString(7, catatan);
            ps.executeUpdate();
        }
    }

    private void updatePet(HttpServletRequest request) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String nama = request.getParameter("nama");
        String jenis = request.getParameter("jenis");
        String ras = request.getParameter("ras");
        int usia = (request.getParameter("usia") != null && !request.getParameter("usia").isEmpty()) 
                   ? Integer.parseInt(request.getParameter("usia")) : 0;
        String catatan = request.getParameter("catatan");

        Part fotoPart = request.getPart("foto");
        String uploadPath = getServletContext().getRealPath("/") + "img";
        
        if (fotoPart != null && fotoPart.getSize() > 0) {
            // Jika user upload foto baru
            String fileName = System.currentTimeMillis() + "_" + fotoPart.getSubmittedFileName();
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();
            fotoPart.write(uploadPath + File.separator + fileName);

            String sql = "UPDATE pets SET nama=?, jenis=?, ras=?, usia=?, catatan=?, foto=? WHERE id=?";
            try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, nama);
                ps.setString(2, jenis);
                ps.setString(3, ras);
                ps.setInt(4, usia);
                ps.setString(5, catatan);
                ps.setString(6, fileName);
                ps.setInt(7, id);
                ps.executeUpdate();
            }
        } else {
            // Jika user TIDAK upload foto baru, foto lama tetap di DB
            String sql = "UPDATE pets SET nama=?, jenis=?, ras=?, usia=?, catatan=? WHERE id=?";
            try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, nama);
                ps.setString(2, jenis);
                ps.setString(3, ras);
                ps.setInt(4, usia);
                ps.setString(5, catatan);
                ps.setInt(6, id);
                ps.executeUpdate();
            }
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        int userId = (int) request.getSession().getAttribute("user_id");
        Map<String, Object> pet = new HashMap<>();

        String sql = "SELECT * FROM pets WHERE id = ? AND user_id = ?";
        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                pet.put("id", rs.getInt("id"));
                pet.put("nama", rs.getString("nama"));
                pet.put("jenis", rs.getString("jenis"));
                pet.put("ras", rs.getString("ras"));
                pet.put("usia", rs.getInt("usia"));
                pet.put("foto", rs.getString("foto"));
                pet.put("catatan", rs.getString("catatan"));
            }
        }
        request.setAttribute("pet", pet);
        request.getRequestDispatcher("/pet/detail.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        int userId = (int) request.getSession().getAttribute("user_id");

        try (Connection conn = DB.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM pets WHERE id = ? AND user_id = ?");
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                request.setAttribute("pet_id", rs.getInt("id"));
                request.setAttribute("nama", rs.getString("nama"));
                request.setAttribute("jenis", rs.getString("jenis"));
                request.setAttribute("ras", rs.getString("ras"));
                request.setAttribute("usia", rs.getInt("usia"));
                request.setAttribute("foto", rs.getString("foto"));
                request.setAttribute("catatan", rs.getString("catatan"));
            }
        }
        request.getRequestDispatcher("/pet/edit.jsp").forward(request, response);
    }

    private void deletePet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        int userId = (int) request.getSession().getAttribute("user_id");
        String sql = "DELETE FROM pets WHERE id = ? AND user_id = ?";
        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
        response.sendRedirect(request.getContextPath() + "/dashboard-owner");
    }
}
