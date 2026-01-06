<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String petId = request.getParameter("pet_id");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Tambah Data Pertumbuhan</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f0f2f5;
                margin: 0;
                padding: 20px;
            }
            .card {
                background: white;
                max-width: 500px;
                margin: 50px auto;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            .header-form {
                color: #6221ff;
                margin-bottom: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                color: #666;
            }
            input, textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 8px;
                box-sizing: border-box;
            }
            .btn-submit {
                background: #6221ff;
                color: white;
                border: none;
                padding: 12px;
                width: 100%;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                margin-top: 10px;
            }
            .btn-cancel {
                display: block;
                text-align: center;
                margin-top: 15px;
                color: #999;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h2 class="header-form">Tambah Data Pertumbuhan</h2>
            <form action="<%= request.getContextPath()%>/pet/tracker" method="post">
                <input type="hidden" name="pet_id" value="<%= petId%>">

                <div class="form-group">
                    <label>Tanggal</label>
                    <input type="date" name="tanggal" required value="<%= new java.sql.Date(System.currentTimeMillis())%>">
                </div>
                <div class="form-group">
                    <label>Berat (kg)</label>
                    <input type="number" step="0.1" name="berat" required>
                </div>
                <div class="form-group">
                    <label>Tinggi (cm)</label>
                    <input type="number" step="0.1" name="tinggi" required>
                </div>
                <div class="form-group">
                    <label>Catatan</label>
                    <textarea name="catatan" rows="3"></textarea>
                </div>
                <button type="submit" class="btn-submit">Simpan Data</button>
                <a href="<%= request.getContextPath()%>/pet/tracker?pet_id=<%= petId%>" class="btn-cancel">Batal</a>
            </form>
        </div>
    </body>
</html>