<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Peta Klinik</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
            body{
                margin:0;
                font-family:Arial
            }
            header{
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #2d6cdf;
                color: white;
                padding: 15px 20px;
            }
            header a{
                color: white;
                text-decoration: none;
                font-weight: bold;
                display: flex;
                align-items: center;
            }
            header a i{
                margin-right: 5px;
            }
            .container{
                display:flex;
                height:calc(100vh - 60px)
            }
            .sidebar{
                width:30%;
                background:#f4f6f8;
                padding:15px;
                overflow-y:auto
            }
            .clinic{
                background:#fff;
                padding:10px;
                margin-bottom:10px;
                border-radius:6px
            }
            .map{
                width:70%
            }
            iframe{
                width:100%;
                height:100%;
                border:0
            }
        </style>
    </head>

    <body>

        <!-- HEADER BARU SESUAI PERMINTAAN -->
        <header>
            <div class="left">
                <a href="<%=request.getContextPath()%>/dashboard-owner">
                    <i class="fa fa-arrow-left"></i> Kembali ke Dashboard
                </a>
            </div>

            <div class="center">
                <h2 style="margin:0">Booking Klinik Hewan</h2>
            </div>

            <div class="right">
                <a href="<%=request.getContextPath()%>/booking?action=reminder">
                    <i class="fa fa-calendar"></i> Lihat Booking
                </a>
            </div>
        </header>

        <div class="container">

            <div class="sidebar">
                <h3>Daftar Klinik</h3>

                <!-- SEARCH -->
                <input type="text"
                       id="search"
                       placeholder="Cari klinik..."
                       style="width:100%;padding:8px;margin-bottom:10px"
                       onkeyup="filterKlinik()">
                <%
                    List<Map<String, Object>> clinics
                            = (List<Map<String, Object>>) request.getAttribute("clinics");

                    if (clinics != null && !clinics.isEmpty()) {
                        for (Map<String, Object> c : clinics) {
                %>
                <div class="clinic"
                     data-nama="<%= c.get("nama")%>"
                     data-alamat="<%= c.get("alamat")%>">
                    <b><%= c.get("nama")%></b><br>
                    <small><%= c.get("alamat")%></small><br>
                    <form action="<%=request.getContextPath()%>/booking" method="get" style="margin-top:5px;">
                        <input type="hidden" name="action" value="form">
                        <input type="hidden" name="klinik_id" value="<%= c.get("id")%>">
                        <button type="submit">Pilih Klinik</button>
                    </form>
                </div>
                <%
                    }
                } else {
                %>
                <p>Data klinik tidak tersedia.</p>
                <%
                    }
                %>
            </div>

            <div class="map">
                <%
                    if (clinics != null && !clinics.isEmpty()) {
                        Map<String, Object> firstClinic = clinics.get(0);
                %>
                <iframe
                    src="https://www.google.com/maps?q=<%=firstClinic.get("latitude")%>,<%=firstClinic.get("longitude")%>&z=15&output=embed"
                    loading="lazy">
                </iframe>
                <%
                    }
                %>
            </div>

        </div>

        <script>
            function pilih(id) {
                // langsung redirect ke servlet booking dengan action=form
                window.location = "<%=request.getContextPath()%>/booking?action=form&klinik_id=" + id;
            }

            function filterKlinik() {
                let keyword = document.getElementById("search").value.toLowerCase();
                let klinikList = document.getElementsByClassName("clinic");

                for (let i = 0; i < klinikList.length; i++) {
                    let nama = klinikList[i].dataset.nama.toLowerCase();
                    let alamat = klinikList[i].dataset.alamat.toLowerCase();

                    if (nama.includes(keyword) || alamat.includes(keyword)) {
                        klinikList[i].style.display = "block";
                    } else {
                        klinikList[i].style.display = "none";
                    }
                }
            }
        </script>

    </body>
</html>
