<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    Map klinik = (Map) request.getAttribute("klinik");
    List pets = (List) request.getAttribute("pets");

    if (klinik == null) {
        response.sendRedirect(request.getContextPath() + "/booking");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Form Booking</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial;
                padding: 20px;
                background: #f4f6f8;
            }
            .card {
                background: white;
                padding: 30px;
                border-radius: 12px;
                max-width: 500px;
                margin: auto;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            h2 {
                color: #333;
                margin-top: 0;
            }
            label {
                font-weight: bold;
                display: block;
                margin-top: 15px;
                color: #555;
            }
            input, select, button {
                width: 100%;
                padding: 12px;
                margin: 8px 0;
                border-radius: 8px;
                border: 1px solid #ddd;
                box-sizing: border-box;
                font-size: 14px;
            }
            button {
                background: #6221ff;
                color: white;
                border: none;
                cursor: pointer;
                font-weight: bold;
                margin-top: 20px;
            }
            button:hover {
                background: #4b18cc;
            }
            .back-link {
                display: block;
                text-align: center;
                margin-top: 15px;
                color: #888;
                text-decoration: none;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h2>Booking di <%= klinik.get("nama")%></h2>
            <form action="<%=request.getContextPath()%>/booking" method="post">
                <input type="hidden" name="klinik_id" value="<%= klinik.get("id")%>">

                <label>Pilih Hewan:</label>
                <select name="pet_id" required>
                    <% if (pets != null && !pets.isEmpty()) {
                        for (Object obj : pets) {
                            Map p = (Map) obj;%>
                    <option value="<%= p.get("id")%>"><%= p.get("nama")%> (<%= p.get("jenis")%>)</option>
                    <% }
                } else { %>
                    <option value="" disabled>Daftarkan hewan Anda terlebih dahulu</option>
                    <% }%>
                </select>

                <label>Tanggal Kedatangan:</label>
                <input type="date" name="tanggal" required>

                <label>Keperluan:</label>
                <select name="keperluan" required>
                    <option value="" disabled selected>-- Pilih Keperluan --</option>
                    <option value="Vaksinasi">Vaksinasi</option>
                    <option value="Konsultasi">Konsultasi</option>
                    <option value="Check-up">Check-up Rutin</option>
                    <option value="Grooming">Grooming</option>
                    <option value="Operasi/Bedah">Operasi/Bedah</option>
                    <option value="Lainnya">Lainnya</option>
                </select>

                <button type="submit">Konfirmasi Booking</button>
            </form>
            <a href="<%=request.getContextPath()%>/booking" class="back-link">← Kembali ke Peta</a>
        </div>
    </body>
</html>