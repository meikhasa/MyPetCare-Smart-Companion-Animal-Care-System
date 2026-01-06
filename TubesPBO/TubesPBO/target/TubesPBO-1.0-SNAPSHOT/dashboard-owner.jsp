<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <title>Dashboard Owner | MyPetCare</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dashboard-owner.css">
        <style>
            /* Navigasi profil di header */
            .user-profile-wrapper {
                display: flex;
                align-items: center;
                gap: 12px;
                background: rgba(255, 255, 255, 0.15);
                padding: 5px 15px 5px 5px;
                border-radius: 30px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: background 0.3s ease;
            }

            .user-profile-wrapper:hover {
                background: rgba(255, 255, 255, 0.25);
            }

            .user-avatar {
                width: 35px;
                height: 35px;
                background-color: #6221ff;
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 16px;
                border: 2px solid white;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .user-info-text {
                display: flex;
                flex-direction: column;
                line-height: 1.2;
                text-align: left;
            }

            .user-name {
                font-size: 14px;
                font-weight: 600;
                color: white;
            }

            .user-role {
                font-size: 11px;
                color: rgba(255, 255, 255, 0.8);
                font-weight: 400;
            }
        </style>
    </head>
    <body class="owner-dashboard">

        <div class="hero-container">
            <div class="hero">
                <div class="hero-left">
                    <h1>Selamat Datang di MyPetCare 🐾</h1>
                    <p>Kelola kesehatan dan kebutuhan hewan peliharaan Anda dengan mudah</p>
                </div>
                <div class="hero-actions">
                    <a href="<%= request.getContextPath()%>/profile" style="text-decoration: none;">
                        <div class="user-profile-wrapper">
                            <div class="user-avatar">
                                <%
                                    String username = (String) session.getAttribute("username");
                                    String initial = (username != null && !username.isEmpty()) ? username.substring(0, 1).toUpperCase() : "U";
                                %>
                                <%= initial%>
                            </div>
                            <div class="user-info-text">
                                <span class="user-name"><%= (username != null) ? username : "User"%></span>
                                <span class="user-role">Pet Owner</span>
                            </div>
                        </div>
                    </a>

                    <button id="theme-toggle" title="Toggle Mode">🌙</button>
                    <a href="<%=request.getContextPath()%>/LogoutServlet" class="logout-btn">Logout</a>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="stats">
                <div class="stat-card">
                    <span class="icon blue">🐾</span>
                    <div>
                        <h3><%= request.getAttribute("totalPets") == null ? 0 : request.getAttribute("totalPets")%></h3>
                        <p>Total Hewan</p>
                    </div>
                </div>
                <div class="stat-card">
                    <span class="icon green">📅</span>
                    <div>
                        <h3><%= request.getAttribute("totalBooking") == null ? 0 : request.getAttribute("totalBooking")%></h3>
                        <p>Booking Aktif</p>
                    </div>
                </div>
                <div class="stat-card">
                    <span class="icon purple">📈</span>
                    <div>
                        <h3><%= request.getAttribute("totalGrowthLogs") == null ? 0 : request.getAttribute("totalGrowthLogs")%></h3>
                        <p>Log Pertumbuhan</p>
                    </div>
                </div>
                <div class="stat-card">
                    <span class="icon orange">🛒</span>
                    <div>
                        <h3><%= request.getAttribute("totalKeranjang") == null ? 0 : request.getAttribute("totalKeranjang")%></h3>
                        <p>Item Keranjang</p>
                    </div>
                </div>
            </div>

            <div class="card">
                <h2>Aksi Cepat</h2>
                <div class="actions">
                    <a href="<%= request.getContextPath()%>/pet" class="action">
                        🐾 Hewan Saya
                        <span>Lihat & kelola hewan</span>
                    </a>
                    <a href="<%=request.getContextPath()%>/booking?action=map" class="action">
                        📅 Booking Klinik
                        <span>Jadwalkan kunjungan</span>
                    </a>
                    <a href="<%=request.getContextPath()%>/pet" class="action">
                        📈 Log Pertumbuhan
                        <span>Catat perkembangan</span>
                    </a>
                    <a href="<%=request.getContextPath()%>/belanja" class="action">
                        🛒 Belanja
                        <span>Kebutuhan pet</span>
                    </a>
                </div>
            </div>

            <div class="grid">
                <div class="card">
                    <h2>Booking Terbaru</h2>
                    <%
                        List<Map<String, Object>> bookings = (List<Map<String, Object>>) request.getAttribute("bookings");
                        if (bookings == null || bookings.isEmpty()) {
                    %>
                    <p style="color:#777">Belum ada booking</p>
                    <%
                    } else {
                        for (Map<String, Object> b : bookings) {
                    %>
                    <div class="booking">
                        <strong><%= b.get("klinik")%></strong>
                        <p><%= b.get("layanan")%> - <%= b.get("pet")%></p>
                        <span style="font-size: 12px; color: #666;"><%= b.get("tanggal")%></span>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>

                <div class="card">
                    <h2>Hewan Peliharaan Saya</h2>
                    <%
                        List<Map<String, Object>> pets = (List<Map<String, Object>>) request.getAttribute("pets");
                        if (pets == null || pets.isEmpty()) {
                    %>
                    <p style="color:#777">Belum ada hewan terdaftar</p>
                    <%
                    } else {
                        for (Map<String, Object> p : pets) {
                            // Mengambil foto unik untuk setiap baris data (p)
                            Object fotoObj = p.get("foto");
                            String fotoHewan = (fotoObj != null && !fotoObj.toString().isEmpty())
                                    ? fotoObj.toString()
                                    : "default-pet.jpg";
                    %>
                    <div class="pet-item" style="display: flex; align-items: center; gap: 15px; margin-bottom: 15px;">
                        <div class="avatar" style="width: 50px; height: 50px; overflow: hidden; border-radius: 50%; border: 2px solid #6221ff; background: #eee;">
                            <%-- Tambahkan System.currentTimeMillis() untuk menghindari Cache Browser --%>
                            <img src="<%= request.getContextPath()%>/img/<%= fotoHewan%>?t=<%= System.currentTimeMillis()%>" 
                                 style="width: 100%; height: 100%; object-fit: cover;"
                                 onerror="this.src='<%= request.getContextPath()%>/img/default-pet.jpg'">
                        </div>
                        <div>
                            <strong style="display: block;"><%= p.get("nama")%></strong>
                            <p style="margin: 0; font-size: 12px; color: #666;"><%= p.get("jenis")%> - <%= p.get("usia")%> tahun</p>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const toggle = document.getElementById('theme-toggle');
                if (localStorage.getItem('theme') === 'dark') {
                    document.body.classList.add('dark-mode');
                    toggle.textContent = '☀️';
                }
                toggle.addEventListener('click', () => {
                    document.body.classList.toggle('dark-mode');
                    const isDark = document.body.classList.contains('dark-mode');
                    localStorage.setItem('theme', isDark ? 'dark' : 'light');
                    toggle.textContent = isDark ? '☀️' : '🌙';
                });
            });
        </script>
    </body>
</html>