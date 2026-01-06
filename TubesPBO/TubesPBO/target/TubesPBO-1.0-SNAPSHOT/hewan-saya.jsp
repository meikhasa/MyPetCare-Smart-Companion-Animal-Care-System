<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Hewan Saya | MyPetCare</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/hewan-saya.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .actions {
                display: flex;
                gap: 8px;
                align-items: center;
                margin-top: 15px;
            }
            .btn-tracker {
                background-color: #f39c12; 
                color: white;
                padding: 8px 12px;
                border-radius: 5px;
                text-decoration: none;
                font-size: 14px;
                flex-grow: 1;
                text-align: center;
            }
            .btn-tracker:hover {
                background-color: #e67e22;
            }
            .btn-detail {
                flex-grow: 1;
                text-align: center;
                background-color: #3498db;
                color: white;
                padding: 8px 12px;
                border-radius: 5px;
                text-decoration: none;
                font-size: 14px;
            }
            .btn-detail:hover {
                background-color: #2980b9;
            }
            .card img {
                width: 100%;
                height: 200px;
                object-fit: cover; 
                border-radius: 10px 10px 0 0;
                display: block;
            }
            .no-image {
                width: 100%;
                height: 200px;
                background: #eee;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 50px;
                color: #ccc;
                border-radius: 10px 10px 0 0;
            }
        </style>
    </head>
    <body>

        <div class="header">
            <a href="<%= request.getContextPath()%>/dashboard-owner" class="back">
                <i class="fa fa-arrow-left"></i> Kembali ke Dashboard
            </a>

            <h2>Hewan Saya</h2>

            <a href="<%= request.getContextPath()%>/pet?action=add" class="btn-add">
                <i class="fa fa-plus"></i> Tambah Hewan
            </a>
        </div>

        <div class="container">
            <%
                List<Map<String, Object>> pets = (List<Map<String, Object>>) request.getAttribute("pets");

                if (pets == null || pets.isEmpty()) {
            %>
            <div style="grid-column: 1/-1; text-align:center; margin-top:40px;">
                <i class="fa fa-paw" style="font-size: 48px; color: #ccc;"></i>
                <p style="color: #777; margin-top: 10px;">Belum ada data hewan.</p>
            </div>
            <%
            } else {
                for (Map<String, Object> p : pets) {
                    // Cek ketersediaan foto di DB
                    String fotoPet = (p.get("foto") != null && !p.get("foto").toString().isEmpty())
                            ? p.get("foto").toString() : "default-pet.jpg";
            %>

            <div class="card">
                <img src="<%= request.getContextPath()%>/img/<%= fotoPet%>?t=<%= System.currentTimeMillis()%>"
                     alt="pet" 
                     onerror="this.onerror=null;this.src='<%= request.getContextPath()%>/img/default-pet.jpg';">

                <div class="card-body">
                    <h3 style="margin: 0; color: #333;"><%= p.get("nama")%></h3>
                    <p style="margin: 5px 0; color: #666;">
                        <%= (p.get("jenis") != null) ? p.get("jenis") : "-" %> • 
                        <%= (p.get("ras") != null) ? p.get("ras") : "-" %>
                    </p>
                    <p style="font-size: 14px; color: #888;"><%= p.get("usia")%> tahun</p>

                    <div class="actions">
                        <a href="<%= request.getContextPath()%>/pet?action=detail&id=<%= p.get("id")%>"
                           class="btn-detail">Detail</a>

                        <a href="<%= request.getContextPath()%>/pet/tracker?pet_id=<%= p.get("id")%>"
                           class="btn-tracker" title="Lihat Log Pertumbuhan">
                            <i class="fa fa-chart-line"></i> Log
                        </a>

                        <a href="<%= request.getContextPath()%>/pet?action=delete&id=<%= p.get("id")%>"
                           class="icon delete"
                           style="text-decoration: none; color: #e74c3c; font-size: 20px;"
                           onclick="return confirm('Hapus <%= p.get("nama")%> dari daftar?')">
                            <i class="fa fa-trash"></i>
                        </a>
                    </div>
                </div>
            </div>

            <%
                    }
                }
            %>
        </div>

    </body>
</html>