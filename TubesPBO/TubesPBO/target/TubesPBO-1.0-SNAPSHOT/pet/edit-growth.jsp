<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String id = request.getParameter("id");
    String petId = request.getParameter("pet_id");
    String tanggal = request.getParameter("tanggal");
    String berat = request.getParameter("berat");
    String tinggi = request.getParameter("tinggi");
    String catatan = request.getParameter("catatan");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Pertumbuhan</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f0f2f5;
                padding: 20px;
            }
            .card {
                background: white;
                max-width: 450px;
                margin: 40px auto;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            input, textarea {
                width: 100%;
                padding: 10px;
                margin-top: 5px;
                margin-bottom: 15px;
                border: 1px solid #ddd;
                border-radius: 6px;
                box-sizing: border-box;
            }
            .btn-save {
                background: #6221ff;
                color: white;
                border: none;
                padding: 12px;
                width: 100%;
                border-radius: 6px;
                font-weight: bold;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h2 style="color: #6221ff;">Edit Data</h2>
            <form action="<%= request.getContextPath()%>/pet/tracker" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= id%>">
                <input type="hidden" name="pet_id" value="<%= petId%>">

                <label>Tanggal</label>
                <input type="date" name="tanggal" required value="<%= tanggal%>">

                <label>Berat (kg)</label>
                <input type="number" step="0.1" name="berat" required value="<%= berat%>">

                <label>Tinggi (cm)</label>
                <input type="number" step="0.1" name="tinggi" required value="<%= tinggi%>">

                <label>Catatan</label>
                <textarea name="catatan" rows="3"><%= (catatan != null && !catatan.equals("null")) ? catatan : ""%></textarea>

                <button type="submit" class="btn-save">Simpan Perubahan</button>
                <a href="<%= request.getContextPath()%>/pet/tracker?pet_id=<%= petId%>" style="display: block; text-align: center; margin-top: 10px; color: #888; text-decoration: none;">Batal</a>
            </form>
        </div>
    </body>
</html>