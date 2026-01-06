<%-- 
    Document   : dashboard-admin
    Created on : Dec 16, 2025, 12:38:16 AM
    Author     : achma
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard Admin</title>
        <link rel="stylesheet" href="css/dashboard.css">
    </head>
    <body class="admin">

        <div class="dashboard">
            <div class="sidebar">
                <h2>ADMIN</h2>
                <a href="#">Dashboard</a>
                <a href="#">Data User</a>
                <a href="#">Data Klinik</a>
                <a href="#">Data Hewan</a>
                <a class="logout" href="logout.jsp">Logout</a>
            </div>

            <div class="main">
                <div class="header">
                    <h1>Dashboard Admin</h1>
                </div>

                <div class="cards">
                    <div class="card">
                        <h3>Total User</h3>
                        <p>120</p>
                    </div>
                    <div class="card">
                        <h3>Total Klinik</h3>
                        <p>15</p>
                    </div>
                    <div class="card">
                        <h3>Total Hewan</h3>
                        <p>230</p>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
