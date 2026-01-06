<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    Map userData = (Map) request.getAttribute("userData");
    // Ambil list riwayat dari request attribute yang dikirim ProfileServlet
    List<Map<String, Object>> riwayat = (List<Map<String, Object>>) request.getAttribute("riwayat");

    if (userData == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard-owner");
        return;
    }
    String profilePic = (userData.get("profile_pic") != null) ? userData.get("profile_pic").toString() : "default_user.png";
    String displayName = (userData.get("display_name") != null) ? userData.get("display_name").toString() : "";
    String gender = (userData.get("gender") != null) ? userData.get("gender").toString() : "Lainnya";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Profil Saya | MyPetCare</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dashboard-owner.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .profile-container {
                max-width: 550px;
                margin: 50px auto;
                background: white;
                padding: 40px;
                border-radius: 24px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            }
            .avatar-wrapper {
                position: relative;
                width: 130px;
                margin: 0 auto 30px;
            }
            .profile-img-big {
                width: 130px;
                height: 130px;
                border-radius: 50%;
                object-fit: cover;
                border: 5px solid #f3e8ff;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            .upload-label {
                position: absolute;
                bottom: 5px;
                right: 5px;
                background: #6221ff;
                color: white;
                width: 35px;
                height: 35px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                border: 3px solid white;
            }
            .info-card {
                background: #f9fafb;
                padding: 25px;
                border-radius: 16px;
                text-align: left;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                font-size: 12px;
                color: #888;
                display: block;
                margin-bottom: 5px;
                font-weight: 600;
            }
            .form-group input, .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                box-sizing: border-box;
            }
            .readonly-field {
                background: #e5e7eb;
                cursor: not-allowed;
            }
            .btn-save {
                width: 100%;
                padding: 12px;
                background: #6221ff;
                color: white;
                border: none;
                border-radius: 10px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 20px;
            }
            .btn-save:hover {
                background: #4b18cc;
            }

            /* CSS Baru untuk Riwayat Belanja */
            .history-section {
                margin-top: 40px;
                text-align: left;
            }
            .history-title {
                font-size: 18px;
                color: #333;
                font-weight: bold;
                margin-bottom: 15px;
                border-bottom: 2px solid #f3e8ff;
                padding-bottom: 5px;
            }
            .history-item {
                display: flex;
                align-items: center;
                gap: 15px;
                background: #fff;
                padding: 12px;
                border-radius: 12px;
                margin-bottom: 10px;
                border: 1px solid #eee;
            }
            .history-item img {
                width: 50px;
                height: 50px;
                border-radius: 8px;
                object-fit: cover;
            }
            .history-details {
                flex: 1;
            }
            .history-details h4 {
                margin: 0;
                font-size: 14px;
                color: #333;
            }
            .history-details span {
                font-size: 11px;
                color: #888;
            }
            .history-price {
                font-weight: bold;
                color: #6221ff;
                font-size: 13px;
            }
            .no-history {
                text-align: center;
                color: #888;
                font-size: 13px;
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <div class="profile-container">
            <form action="<%= request.getContextPath()%>/profile" method="post" enctype="multipart/form-data">
                <input type="hidden" name="existing_pic" value="<%= profilePic%>">

                <div class="avatar-wrapper">
                    <img src="<%= request.getContextPath()%>/img/<%= profilePic%>" id="previewImg" class="profile-img-big">
                    <label for="fileInput" class="upload-label">
                        <i class="fa fa-camera"></i>
                    </label>
                    <input type="file" id="fileInput" name="profile_pic" style="display:none" accept="image/*">
                </div>

                <div class="info-card">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" class="readonly-field" value="<%= userData.get("username")%>" readonly>
                    </div>

                    <div class="form-group">
                        <label>Nama Lengkap (Owner)</label>
                        <input type="text" name="display_name" value="<%= displayName%>" placeholder="Masukkan nama anda">
                    </div>

                    <div class="form-group">
                        <label>Jenis Kelamin</label>
                        <select name="gender">
                            <option value="Laki-laki" <%= "Laki-laki".equals(gender) ? "selected" : ""%>>Laki-laki</option>
                            <option value="Perempuan" <%= "Perempuan".equals(gender) ? "selected" : ""%>>Perempuan</option>
                            <option value="Lainnya" <%= "Lainnya".equals(gender) ? "selected" : ""%>>Lainnya</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Jenis Akun</label>
                        <input type="text" class="readonly-field" value="<%= userData.get("role").toString().toUpperCase()%>" readonly>
                    </div>

                    <div class="form-group">
                        <label>Bergabung Sejak</label>
                        <p style="margin:0; font-size:14px; font-weight:600;"><%= userData.get("created_at")%></p>
                    </div>

                    <button type="submit" class="btn-save">Simpan Perubahan</button>
                </div>
            </form>

            <div class="history-section">
                <div class="history-title"><i class="fa fa-history"></i> Riwayat Belanja</div>

                <% if (riwayat == null || riwayat.isEmpty()) { %>
                <div class="no-history">Belum ada riwayat transaksi.</div>
                <% } else {
                    for (Map<String, Object> item : riwayat) {
                %>
                <div class="history-item">
                    <img src="<%= request.getContextPath()%>/img/<%= item.get("gambar")%>" onerror="this.src='https://via.placeholder.com/50'">
                    <div class="history-details">
                        <h4><%= item.get("nama")%></h4>
                        <span><%= item.get("tanggal")%> • <%= item.get("qty")%> item</span>
                    </div>
                    <div class="history-price">
                        Rp <%= String.format("%,.0f", (Double) item.get("total")).replace(",", ".")%>
                    </div>
                </div>
                <% }
                }%>
            </div>

            <a href="<%= request.getContextPath()%>/dashboard-owner" class="btn-back" style="display:block; margin-top:20px; text-decoration:none; color:#888; font-size:14px; text-align:center;">
                <i class="fa fa-arrow-left"></i> Kembali ke Dashboard
            </a>
        </div>

        <script>
            document.getElementById('fileInput').onchange = function (evt) {
                const [file] = this.files;
                if (file) {
                    document.getElementById('previewImg').src = URL.createObjectURL(file);
                }
            }
        </script>
    </body>
</html>