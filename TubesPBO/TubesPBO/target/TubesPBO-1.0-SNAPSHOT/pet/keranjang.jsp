<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>

<%
    List<Map<String, Object>> items
            = (List<Map<String, Object>>) request.getAttribute("items");

    Double total = (Double) request.getAttribute("total");
    if (total == null)
        total = 0.0;
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Keranjang Belanja</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/keranjang.css">
    </head>
    <body>

        <div class="market-header">
            <a href="<%= request.getContextPath()%>/belanja" class="back-link">
                ← Kembali ke Katalog
            </a>
            <div class="market-title">Keranjang Belanja</div>
        </div>

        <div class="container">

            <% if (items == null || items.isEmpty()) {%>

            <div class="empty-cart">
                <h3>Keranjang kamu kosong</h3>
                <p>Yuk mulai belanja kebutuhan hewan peliharaanmu 🐾</p>
                <a href="<%= request.getContextPath()%>/belanja" class="btn-start">
                    Mulai Belanja
                </a>
            </div>

            <% } else { %>

            <div class="cart-layout">

                <div class="cart-items">

                    <%
                        int totalItem = 0;
                        for (Map<String, Object> item : items) {
                            int qty = (Integer) item.get("qty");
                            totalItem += qty;
                    %>

                    <div class="cart-item">
                        <img src="<%= request.getContextPath()%>/uploads/<%= item.get("gambar")%>">

                        <div class="info">
                            <h4><%= item.get("nama")%></h4>
                            <p><%= item.get("kategori")%></p>
                            <span>
                                Rp <%= String.format("%,.0f", (Double) item.get("harga")).replace(",", ".")%>
                            </span>
                        </div>

                        <form action="<%= request.getContextPath()%>/keranjang" method="post" class="qty">
                            <input type="hidden" name="id" value="<%= item.get("id")%>">
                            <button type="submit" name="action" value="minus">−</button>
                            <span><%= qty%></span>
                            <button type="submit" name="action" value="plus">+</button>
                        </form>

                    </div>

                    <% }%>

                </div>

                <div class="summary">
                    <h3>Ringkasan Belanja</h3>
                    <p>Total Item <span><%= totalItem%></span></p>
                    <p>Total Harga
                        <span>
                            Rp <%= String.format("%,.0f", total).replace(",", ".")%>
                        </span>
                    </p>
                    <form action="<%= request.getContextPath()%>/checkout" method="post">
                        <button type="submit" class="checkout" style="width: 100%; cursor: pointer;">Checkout</button>
                    </form>
                </div>

            </div>

            <% }%>

        </div>
    </body>
</html>
