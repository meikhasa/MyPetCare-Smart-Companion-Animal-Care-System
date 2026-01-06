<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Booking Reminder</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/reminder.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>

        <header class="top-nav">
            <div class="nav-container">
                <a href="<%=request.getContextPath()%>/booking" class="back-link">
                    <i class="fa fa-arrow-left"></i> Kembali ke Peta
                </a>
                <h2 class="page-title">Booking Reminder</h2>
            </div>
        </header>

        <main class="content-wrapper">
            <%
                Map booking = (Map) request.getAttribute("booking");
                String status = (booking != null && booking.get("status") != null) ? (String) booking.get("status") : "";

                int upc = (booking != null && "AKTIF".equals(status)) ? 1 : 0;
                int com = (booking != null && "COMPLETED".equals(status)) ? 1 : 0;
                int can = (booking != null && "CANCELED".equals(status)) ? 1 : 0;
            %>

            <div class="status-card">
                <h3 class="status-label text-green">Upcoming (<%= upc%>)</h3>
                <% if (upc > 0) {%>
                <div class="inner-details-box">
                    <div class="info-side">
                        <h4 class="clinic-name"><%= booking.get("klinik")%></h4>
                        <p class="clinic-address">Jl. Merdeka No. 45, Jakarta</p>
                        <div class="meta-info">
                            <p>Hewan: <%= booking.get("pet")%></p>
                            <p>Tanggal: <%= booking.get("tanggal")%></p>
                            <p>Keperluan: <%= booking.get("keperluan")%></p>
                        </div>
                    </div>
                    <div class="action-side">
                        <button class="btn-round btn-check" onclick="updateStatus(<%= booking.get("id")%>, 'COMPLETED')"><i class="fa fa-check"></i></button>
                        <button class="btn-round btn-cancel" onclick="updateStatus(<%= booking.get("id")%>, 'CANCELED')"><i class="fa fa-times"></i></button>
                    </div>
                </div>
                <% } else { %> <p class="no-data">Tidak ada booking mendatang</p> <% }%>
            </div>

            <div class="status-card">
                <h3 class="status-label text-blue">Completed (<%= com%>)</h3>
                <% if (com > 0) {%>
                <div class="inner-details-box">
                    <div class="info-side">
                        <h4 class="clinic-name"><%= booking.get("klinik")%></h4>
                        <p>Hewan: <%= booking.get("pet")%></p>
                        <button class="btn-delete" onclick="deletePerm(<%= booking.get("id")%>)">Hapus</button>
                    </div>
                </div>
                <% } else { %> <p class="no-data">Tidak ada booking yang selesai</p> <% }%>
            </div>

            <div class="status-card">
                <h3 class="status-label text-red">Canceled (<%= can%>)</h3>
                <% if (can > 0) {%>
                <div class="inner-details-box">
                    <div class="info-side">
                        <h4 class="clinic-name"><%= booking.get("klinik")%></h4>
                        <p>Hewan: <%= booking.get("pet")%></p>
                        <button class="btn-delete" onclick="deletePerm(<%= booking.get("id")%>)">Hapus</button>
                    </div>
                </div>
                <% } else { %> <p class="no-data">Tidak ada booking yang dibatalkan</p> <% }%>
            </div>
        </main>

        <script>
            function updateStatus(id, s) {
                window.location.href = "<%=request.getContextPath()%>/booking?action=updateStatus&id=" + id + "&status=" + s;
            }
            function deletePerm(id) {
                if (confirm("Hapus permanen dari riwayat?")) {
                    window.location.href = "<%=request.getContextPath()%>/booking?action=delete&id=" + id;
                }
            }
        </script>
    </body>
</html>