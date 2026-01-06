<%-- 
    Document   : pet-form
    Created on : Dec 20, 2025, 6:47:02?AM
    Author     : achma
--%>

<div class="wrapper">
    <div class="sidebar">
        <h2>MyPetCare</h2>
        <a href="<%=request.getContextPath()%>/dashboard-owner.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/pet?action=list" class="active">Daftar Hewan</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet">Logout</a>
    </div>

    <div class="content">
        <div class="form-card">
            <h2>Tambah Hewan</h2>

            <form action="<%=request.getContextPath()%>/pet" 
                  method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="insert">

                <div class="form-group">
                    <label>Nama Hewan</label>
                    <input type="text" name="nama" required>
                </div>

                <div class="form-group">
                    <label>Jenis Hewan</label>
                    <select name="jenis" required>
                        <option value="Kucing">Kucing</option>
                        <option value="Anjing">Anjing</option>
                        <option value="Kelinci">Kelinci</option>
                        <option value="Lainnya">Lainnya</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Ras</label>
                    <input type="text" name="ras">
                </div>

                <div class="form-group">
                    <label>Usia</label>
                    <input type="number" name="usia">
                </div>

                <div class="form-group">
                    <label>Foto Hewan</label>
                    <input type="file" name="foto" accept="image/*">
                </div>

                <div class="form-group">
                    <label>Catatan Tambahan</label>
                    <textarea name="catatan"></textarea>
                </div>

                <div class="form-actions">
                    <button class="btn-primary" type="submit">Tambahkan</button>
                    <a class="btn-secondary" href="<%=request.getContextPath()%>/user/hewan-saya.jsp">
                        Batal
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>
