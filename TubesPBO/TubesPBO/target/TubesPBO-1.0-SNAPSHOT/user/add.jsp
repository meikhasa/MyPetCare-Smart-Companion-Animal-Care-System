<%-- 
    Document   : add
    Created on : Dec 16, 2025, 12:42:47?AM
    Author     : achma
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Tambah Hewan</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/pet-form.css">
</head>
<body>

<div class="form-container">
    <h2>Tambah Hewan</h2>

    <form action="<%=request.getContextPath()%>/pet"
          method="post"
          enctype="multipart/form-data">

        <label>Nama Hewan</label>
        <input type="text" name="nama" required>

        <label>Jenis Hewan</label>
        <select name="jenis">
            <option>Kucing</option>
            <option>Anjing</option>
            <option>Kelinci</option>
            <option>Hamster</option>
            <option>Burung</option>
            <option>Lainnya</option>
        </select>

        <label>Ras</label>
        <input type="text" name="ras">

        <label>Usia (tahun)</label>
        <input type="number" name="usia" required>

        <label>Foto Hewan</label>
        <input type="file" name="foto" accept="image/*" required>

        <label>Catatan</label>
        <textarea name="catatan"></textarea>

        <div class="btn-group">
            <button type="submit">Simpan</button>
            <a href="<%=request.getContextPath()%>/pet?action=dashboard" class="btn-cancel">Batal</a>
        </div>
    </form>
</div>

</body>
</html>
