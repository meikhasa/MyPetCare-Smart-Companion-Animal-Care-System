<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Map" %>
<%
    // Mengambil objek pet yang dikirim dari PetServlet (action=detail)
    Map pet = (Map) request.getAttribute("pet");

    // Proteksi jika data null agar tidak error
    if (pet == null) {
        response.sendRedirect(request.getContextPath() + "/pet");
        return;
    }
    
    // Logika penentuan nama file foto
    String fotoPet = (pet.get("foto") != null && !pet.get("foto").toString().isEmpty()) 
                     ? pet.get("foto").toString() : "default-pet.jpg";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Detail Hewan | MyPetCare</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f0f2f5;
                margin: 0;
            }
            .header-purple {
                background-color: #6221ff;
                color: white;
                padding: 20px 40px;
                display: flex;
                flex-direction: column;
            }
            .header-purple a {
                color: white;
                text-decoration: none;
                font-size: 14px;
                margin-bottom: 10px;
            }
            .header-purple h2 {
                margin: 0;
                font-size: 22px;
            }
            .container {
                max-width: 900px;
                margin: 40px auto;
                padding: 0 20px;
            }
            .card-detail {
                background: white;
                border-radius: 15px;
                padding: 30px;
                display: flex;
                gap: 40px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                align-items: flex-start;
            }
            .photo-side img {
                width: 280px;
                height: 280px;
                object-fit: cover;
                border-radius: 15px;
                border: 5px solid #fff;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .info-side { flex: 1; }
            .pet-name {
                margin: 0 0 15px 0;
                color: #6221ff;
                font-size: 28px;
            }
            .meta-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 25px;
            }
            .meta-item label {
                display: block;
                color: #888;
                font-size: 13px;
                margin-bottom: 5px;
            }
            .meta-item span {
                font-weight: 600;
                color: #333;
                font-size: 16px;
            }
            .catatan-box {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 10px;
                border-left: 4px solid #6221ff;
                margin-bottom: 30px;
            }
            .catatan-box label {
                font-weight: bold;
                font-size: 14px;
                color: #555;
                display: block;
                margin-bottom: 5px;
            }
            .btn-group { display: flex; gap: 15px; }
            .btn-orange {
                background-color: #ff5e00;
                color: white;
                padding: 12px 20px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: bold;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: 0.3s;
            }
            .btn-orange:hover { background-color: #e65500; }
            .btn-blue {
                background-color: #6221ff;
                color: white;
                padding: 12px 25px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: bold;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: 0.3s;
            }
            .btn-blue:hover { background-color: #4b18cc; }
        </style>
    </head>
    <body>
        <header class="header-purple">
            <a href="<%= request.getContextPath()%>/pet"><i class="fa fa-arrow-left"></i> Kembali ke Daftar Hewan</a>
            <h2>Detail Hewan</h2>
        </header>

        <div class="container">
            <div class="card-detail">
                <div class="photo-side">
                    <img src="<%= request.getContextPath()%>/img/<%= fotoPet %>?t=<%= System.currentTimeMillis()%>" 
                         alt="Foto <%= pet.get("nama")%>"
                         onerror="this.src='<%= request.getContextPath()%>/img/default-pet.jpg'">
                </div>

                <div class="info-side">
                    <h1 class="pet-name"><%= pet.get("nama")%></h1>
                    <div class="meta-grid">
                        <div class="meta-item">
                            <label>Jenis Hewan</label>
                            <span><%= pet.get("jenis")%></span>
                        </div>
                        <div class="meta-item">
                            <label>Ras</label>
                            <span><%= (pet.get("ras") == null) ? "-" : pet.get("ras") %></span>
                        </div>
                        <div class="meta-item">
                            <label>Usia</label>
                            <span><%= pet.get("usia")%> Tahun</span>
                        </div>
                    </div>

                    <div class="catatan-box">
                        <label>Catatan Tambahan:</label>
                        <p style="margin:0; color:#555; line-height: 1.5;">
                            <%= (pet.get("catatan") == null || pet.get("catatan").toString().isEmpty()) ? "Tidak ada catatan." : pet.get("catatan")%>
                        </p>
                    </div>

                    <div class="btn-group">
                        <a href="<%= request.getContextPath()%>/pet/tracker?pet_id=<%= pet.get("id")%>" class="btn-orange">
                            <i class="fa fa-chart-line"></i> Lihat Tracker
                        </a>
                        <a href="<%= request.getContextPath()%>/pet?action=edit&id=<%= pet.get("id")%>" class="btn-blue">
                            <i class="fa fa-edit"></i> Edit Data
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>