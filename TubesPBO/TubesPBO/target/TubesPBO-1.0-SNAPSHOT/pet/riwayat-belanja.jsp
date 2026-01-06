<%-- 
    Document   : riwayat-belanja
    Created on : Dec 27, 2025, 4:51:52 PM
    Author     : achma
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, Object>> riwayat = (List<Map<String, Object>>) request.getAttribute("riwayat");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Riwayat Belanja | MyPetCare</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f0f2f5;
                margin: 0;
            }
            .header-purple {
                background-color: #6221ff;
                color: white;
                padding: 20px 40px;
            }
            .header-purple a {
                color: white;
                text-decoration: none;
                font-size: 14px;
            }
            .container {
                max-width: 800px;
                margin: 30px auto;
                padding: 0 20px;
            }
            .order-card {
                background: white;
                border-radius: 15px;
                padding: 20px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 20px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }
            .order-card img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 10px;
            }
            .order-info {
                flex: 1;
            }
            .order-info h4 {
                margin: 0 0 5px 0;
                color: #333;
            }
            .order-info p {
                margin: 0;
                color: #888;
                font-size: 13px;
            }
            .order-price {
                text-align: right;
            }
            .order-price span {
                display: block;
                font-weight: bold;
                color: #6221ff;
                font-size: 16px;
            }
            .status-badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 20px;
                background: #e8f5e9;
                color: #2e7d32;
                font-size: 12px;
                font-weight: bold;
                margin-top: 10px;
            }
            .empty-state {
                text-align: center;
                margin-top: 100px;
                color: #888;
            }
            .empty-state i {
                font-size: 60px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <header class="header-purple">
            <a href="<%= request.getContextPath()%>/profile"><i class="fa fa-arrow-left"></i> Kembali ke Profil</a>
            <h2>Riwayat Belanja</h2>
        </header>

        <div class="container">
            <% if (riwayat == null || riwayat.isEmpty()) {%>
            <div class="empty-state">
                <i class="fa fa-shopping-bag"></i>
                <p>Belum ada transaksi belanja.</p>
                <a href="<%= request.getContextPath()%>/belanja" style="color: #6221ff; text-decoration: none; font-weight: bold;">Mulai Belanja Sekarang</a>
            </div>
            <% } else {
                for (Map<String, Object> item : riwayat) {
            %>
            <div class="order-card">
                <img src="<%= request.getContextPath()%>/img/<%= item.get("gambar")%>" 
                     onerror="this.src='https://via.placeholder.com/80?text=Produk'">

                <div class="order-info">
                    <h4><%= item.get("nama")%></h4>
                    <p><i class="fa fa-calendar-alt"></i> <%= item.get("tanggal")%></p>
                    <div class="status-badge">Selesai</div>
                </div>

                <div class="order-price">
                    <p style="font-size: 12px; color: #888; margin-bottom: 5px;"><%= item.get("qty")%> Item</p>
                    <span>Rp <%= String.format("%,.0f", (Double) item.get("total")).replace(",", ".")%></span>
                </div>
            </div>
            <% }
            }%>
        </div>
    </body>
</html>