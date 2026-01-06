<%-- 
    Document   : belanja
    Created on : Dec 22, 2025, 9:19:33 PM
    Author     : achma
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%
    List<Map<String, Object>> listProduk
            = (List<Map<String, Object>>) request.getAttribute("listProduk");

    String catAktif = (String) request.getAttribute("catAktif");
    if (catAktif == null)
        catAktif = "Semua";
%>
<html>
    <head>
        <title>Marketplace | MyPetCare</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/belanja.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>

        <!-- HEADER UNGU -->
        <div class="market-header">
            <a href="<%= request.getContextPath()%>/dashboard-owner" class="back-link">
                ← Kembali ke Dashboard
            </a>

            <div class="market-title">Marketplace</div>

            <a href="<%= request.getContextPath()%>/keranjang" class="btn-cart">
                <i class="fa fa-shopping-cart"></i> Keranjang
            </a>
        </div>

        <div class="container">

            <!-- FILTER -->
            <div class="filter-bar">
                <%
                    String[] daftarCat = {"Semua", "Makanan", "Mainan", "Aksesoris", "Perawatan", "Kesehatan"};
                    for (String c : daftarCat) {
                %>
                <a href="<%= request.getContextPath()%>/belanja?cat=<%=c%>"
                   class="filter-item <%= catAktif.equals(c) ? "active" : ""%>">
                    <%= c%>
                </a>
                <% } %>
            </div>

            <!-- GRID PRODUK -->
            <div class="product-grid">
                <% if (listProduk != null && !listProduk.isEmpty()) {
                        for (Map<String, Object> p : listProduk) {%>

                <div class="product-card">
                    <img src="<%= request.getContextPath()%>/uploads/<%= p.get("gambar")%>"
                         onerror="this.src='https://via.placeholder.com/400x300?text=Produk'"
                         alt="produk">

                    <div class="card-body">
                        <div class="p-nama"><%= p.get("nama")%></div>
                        <div class="p-kategori"><%= p.get("kategori")%></div>

                        <div class="card-footer">
                            <div class="harga">
                                Rp <%= String.format("%,.0f", (Double) p.get("harga")).replace(",", ".")%>
                                <span>Stok: <%= p.get("stok")%></span>
                            </div>

                            <button class="btn-add" onclick="tambahKeKeranjang(<%= p.get("id")%>)">
                                <i class="fa fa-cart-plus"></i> Tambah ke Keranjang
                            </button>
                        </div>
                    </div>
                </div>

                <% }
                } else { %>
                <p style="grid-column:1/-1;text-align:center;color:#999">
                    Produk belum tersedia
                </p>
                <% }%>
            </div>
        </div>

        <script>
            function tambahKeKeranjang(idProduk) {
                // Mengarahkan ke KeranjangServlet dengan parameter action dan id produk
                window.location.href = "<%= request.getContextPath()%>/keranjang?action=add&id=" + idProduk;
            }
        </script>

    </body>
</html>

