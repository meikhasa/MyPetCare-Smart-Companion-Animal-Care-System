<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, Object>> growthData = (List<Map<String, Object>>) request.getAttribute("growthData");
    int petId = (int) request.getAttribute("pet_id");
    Map pet = (Map) request.getAttribute("pet");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Tracker Pertumbuhan | MyPetCare</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                font-size: 14px;
            }
            .container {
                max-width: 1000px;
                margin: 30px auto;
                padding: 0 20px;
            }
            .card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }
            .flex-between {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .btn-add {
                background: #6221ff;
                color: white;
                padding: 10px 20px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: bold;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th {
                text-align: left;
                padding: 12px;
                border-bottom: 2px solid #eee;
                color: #666;
            }
            td {
                padding: 12px;
                border-bottom: 1px solid #eee;
            }
            .btn-icon {
                border: none;
                background: #f0f0f0;
                padding: 8px;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                color: #333;
                display: inline-block;
            }
            .text-red {
                color: #e74c3c;
            }
        </style>
    </head>
    <body>
        <header class="header-purple">
            <a href="<%= request.getContextPath()%>/pet?action=detail&id=<%= petId%>"><i class="fa fa-arrow-left"></i> Kembali</a>
            <h2>Tracker Pertumbuhan: <%= (pet != null) ? pet.get("nama") : "Hewan"%></h2>
        </header>

        <div class="container">
            <div class="card">
                <h3><i class="fa fa-chart-line"></i> Grafik Pertumbuhan</h3>
                <div style="height: 350px;"><canvas id="growthChart"></canvas></div>
            </div>

            <div class="card">
                <div class="flex-between">
                    <h3><i class="fa fa-history"></i> Riwayat</h3>
                    <a href="<%= request.getContextPath()%>/pet/add-growth.jsp?pet_id=<%= petId%>" class="btn-add"><i class="fa fa-plus"></i> Tambah</a>
                </div>
                <table>
                    <thead>
                        <tr><th>Tanggal</th><th>Berat (kg)</th><th>Tinggi (cm)</th><th>Catatan</th><th>Aksi</th></tr>
                    </thead>
                    <tbody>
                        <% if (growthData == null || growthData.isEmpty()) { %>
                        <tr><td colspan="5" style="text-align: center;">Belum ada data.</td></tr>
                        <% } else {
                            for (Map<String, Object> d : growthData) {%>
                        <tr>
                            <td><%= d.get("tanggal")%></td>
                            <td><%= d.get("berat")%> kg</td>
                            <td><%= d.get("tinggi")%> cm</td>
                            <td><%= (d.get("catatan") != null) ? d.get("catatan") : "-"%></td>
                            <td>
                                <a href="<%= request.getContextPath()%>/pet/edit-growth.jsp?id=<%= d.get("id")%>&pet_id=<%= petId%>&tanggal=<%= d.get("tanggal")%>&berat=<%= d.get("berat")%>&tinggi=<%= d.get("tinggi")%>&catatan=<%= d.get("catatan")%>" class="btn-icon">
                                    <i class="fa fa-pencil"></i>
                                </a>
                                <a href="javascript:void(0);" onclick="confirmDelete('<%= d.get("id")%>', '<%= petId%>')" class="btn-icon text-red">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% }
                            }%>
                    </tbody>
                </table>
            </div>
        </div>

        <script>
            function confirmDelete(id, petId) {
                if (confirm("Hapus data ini?")) {
                    window.location.href = "<%= request.getContextPath()%>/pet/tracker?action=delete&id=" + id + "&pet_id=" + petId;
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                const ctx = document.getElementById('growthChart').getContext('2d');
                const labels = [];
                const weightData = [];
                const heightData = [];
            <% if (growthData != null) {
                        for (Map<String, Object> d : growthData) {%>
                labels.push("<%= d.get("tanggal")%>");
                weightData.push(<%= d.get("berat")%>);
                heightData.push(<%= d.get("tinggi")%>);
            <% }
                    }%>
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [
                            {label: 'Berat (kg)', data: weightData, borderColor: '#6221ff', tension: 0.3, fill: true, backgroundColor: 'rgba(98, 33, 255, 0.1)'},
                            {label: 'Tinggi (cm)', data: heightData, borderColor: '#2ecc71', tension: 0.3, fill: true, backgroundColor: 'rgba(46, 204, 113, 0.1)'}
                        ]
                    },
                    options: {responsive: true, maintainAspectRatio: false}
                });
            });
        </script>
    </body>
</html>