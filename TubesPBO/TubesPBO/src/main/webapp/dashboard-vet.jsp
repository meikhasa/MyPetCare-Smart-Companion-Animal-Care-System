<%-- 
    Document   : dashboard-vet
    Created on : Dec 16, 2025, 12:38:41 AM
    Author     : achma
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Vet - MyPetCare</title>
    <link rel="stylesheet" href="css/dashboard-vet.css">
</head>
<body>

<div class="sidebar">
    <h2 class="logo">MyPetCare</h2>

    <a href="dashboard-vet.jsp" class="active">Dashboard</a>
    <a href="KlinikServlet?action=listPatients">Daftar Pasien</a>
    <a href="KlinikServlet?action=schedule">Jadwal Pemeriksaan</a>
    <a href="KlinikServlet?action=history">Riwayat</a>
    <a href="LogoutServlet">Logout</a>
</div>

<div class="content">
    <h1>Dashboard Dokter Hewan</h1>

    <div class="cards">
        <div class="card">
            <h3>Total Pasien Hari Ini</h3>
            <p>10</p>
        </div>

        <div class="card">
            <h3>Janji Temu Berikutnya</h3>
            <p>14:30 - Kucing (Milo)</p>
        </div>

        <div class="card">
            <h3>Riwayat Pemeriksaan</h3>
            <p>120 records</p>
        </div>
    </div>

    <h2>Jadwal Pemeriksaan Hari Ini</h2>

    <table class="table">
        <tr>
            <th>Nama Hewan</th>
            <th>Jenis</th>
            <th>Owner</th>
            <th>Jam</th>
        </tr>
        <tr>
            <td>Milo</td>
            <td>Kucing</td>
            <td>Andi</td>
            <td>14:30</td>
        </tr>
        <tr>
            <td>Rocky</td>
            <td>Anjing</td>
            <td>Budi</td>
            <td>15:00</td>
        </tr>
    </table>
</div>
<script src="js/app.js"></script>
</body>
</html>

