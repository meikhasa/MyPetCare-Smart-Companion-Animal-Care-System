<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int petId = (int) request.getAttribute("pet_id");
    String currentFoto = (request.getAttribute("foto") != null && !request.getAttribute("foto").toString().isEmpty())
            ? request.getAttribute("foto").toString() : "default-pet.jpg";

    // Ambil data jenis dan ras dari request attribute
    String jenisHewan = (request.getAttribute("jenis") != null) ? request.getAttribute("jenis").toString() : "";
    String rasHewan = (request.getAttribute("ras") != null) ? request.getAttribute("ras").toString() : "";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Hewan | MyPetCare</title>
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
            }
            .container {
                max-width: 600px;
                margin: 40px auto;
                padding: 0 20px;
            }
            .card {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: #333;
            }
            input, select, textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                box-sizing: border-box;
            }
            .btn-submit {
                background: #6221ff;
                color: white;
                border: none;
                padding: 15px;
                width: 100%;
                border-radius: 8px;
                font-weight: bold;
                cursor: pointer;
                font-size: 16px;
                margin-top: 10px;
            }
            .btn-cancel {
                display: block;
                text-align: center;
                margin-top: 15px;
                color: #888;
                text-decoration: none;
            }
            .img-preview {
                width: 150px;
                height: 150px;
                object-fit: cover;
                border-radius: 10px;
                margin-bottom: 10px;
                display: block;
                border: 2px solid #ddd;
            }
            .required {
                color: red;
            }
        </style>
    </head>
    <body>
        <header class="header-purple">
            <a href="<%= request.getContextPath()%>/pet?action=detail&id=<%= petId%>"><i class="fa fa-arrow-left"></i> Kembali ke Detail</a>
            <h2>Edit Data Hewan</h2>
        </header>

        <div class="container">
            <div class="card">
                <form action="<%= request.getContextPath()%>/pet?action=update" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="<%= petId%>">

                    <div class="form-group">
                        <label>Nama Hewan <span class="required">*</span></label>
                        <input type="text" name="nama" value="<%= request.getAttribute("nama")%>" required>
                    </div>

                    <div class="form-group">
                        <label>Jenis Hewan <span class="required">*</span></label>
                        <select name="jenis" required>
                            <option value="">-- Pilih Jenis --</option>
                            <option value="Kucing" <%= jenisHewan.equals("Kucing") ? "selected" : ""%>>Kucing</option>
                            <option value="Anjing" <%= jenisHewan.equals("Anjing") ? "selected" : ""%>>Anjing</option>
                            <option value="Kelinci" <%= jenisHewan.equals("Kelinci") ? "selected" : ""%>>Kelinci</option>
                            <option value="Burung" <%= jenisHewan.equals("Burung") ? "selected" : ""%>>Burung</option>
                            <option value="Hamster" <%= jenisHewan.equals("Hamster") ? "selected" : ""%>>Hamster</option>
                            <option value="Lainnya" <%= jenisHewan.equals("Lainnya") ? "selected" : ""%>>Lainnya</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Ras Hewan <span class="required">*</span></label>
                        <input type="text" name="ras" value="<%= rasHewan%>" placeholder="Contoh: Persia, Golden Retriever, dll" required>
                    </div>

                    <div class="form-group">
                        <label>Usia (Tahun) <span class="required">*</span></label>
                        <input type="number" name="usia" value="<%= request.getAttribute("usia")%>" step="0.1" required>
                    </div>

                    <div class="form-group">
                        <label>Foto Saat Ini</label>
                        <img id="preview" src="<%= request.getContextPath()%>/img/<%= currentFoto%>?t=<%= System.currentTimeMillis()%>" class="img-preview">

                        <label>Ganti Foto (Kosongkan jika tidak ingin ganti)</label>
                        <input type="file" name="foto" id="fotoInput" accept="image/*">
                    </div>

                    <div class="form-group">
                        <label>Catatan Tambahan</label>
                        <textarea name="catatan" rows="4" placeholder="Riwayat medis atau kebiasaan hewan..."><%= request.getAttribute("catatan")%></textarea>
                    </div>

                    <button type="submit" class="btn-submit">Simpan Perubahan</button>
                    <a href="<%= request.getContextPath()%>/pet?action=detail&id=<%= petId%>" class="btn-cancel">Batal</a>
                </form>
            </div>
        </div>

        <script>
            document.getElementById('fotoInput').onchange = function (evt) {
                const [file] = this.files;
                if (file) {
                    document.getElementById('preview').src = URL.createObjectURL(file);
                }
            }
        </script>
    </body>
</html>