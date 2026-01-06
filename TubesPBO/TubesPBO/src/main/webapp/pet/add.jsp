<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Tambah Hewan | MyPetCare</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/pet-form.css">
</head>
<body>

<div class="form-container">
    <h2>Tambah Hewan</h2>

    <form action="<%= request.getContextPath() %>/pet"
          method="post"
          enctype="multipart/form-data">

        <div class="form-group">
            <label>Nama Hewan</label>
            <input type="text" name="nama" required>
        </div>

        <div class="form-group">
            <label>Jenis</label>
            <select name="jenis" required>
                <option value="">-- Pilih Jenis --</option>
                <option>Kucing</option>
                <option>Anjing</option>
                <option>Kelinci</option>
                <option>Hamster</option>
                <option>Burung</option>
                <option>Lainnya</option>
            </select>
        </div>

        <div class="form-group">
            <label>Ras</label>
            <input type="text" name="ras">
        </div>

        <div class="form-group">
            <label>Usia (tahun)</label>
            <input type="number" name="usia" min="0" required>
        </div>

        <div class="form-group">
            <label>Foto Hewan</label>
            <input type="file" name="foto" accept="image/*" required>
        </div>

        <div class="form-group">
            <label>Catatan</label>
            <textarea name="catatan"></textarea>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-submit">Simpan</button>

            <!-- TOMBOL BATAL YANG BENAR -->
            <a href="<%= request.getContextPath() %>/pet"
               class="btn-cancel">Batal</a>
        </div>

    </form>
</div>

</body>
</html>
