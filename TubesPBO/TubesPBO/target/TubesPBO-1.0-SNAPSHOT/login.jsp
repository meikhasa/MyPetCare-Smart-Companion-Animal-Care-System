<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login | MyPetCare</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body class="login-body">

<div class="login-container">
    <h2>MyPetCare</h2>
    <p class="subtitle">Login ke sistem perawatan hewan</p>

    <%-- NOTIFIKASI BERHASIL DAFTAR --%>
    <% if ("success".equals(request.getParameter("status"))) { %>
        <div style="background-color: #d4edda; color: #155724; padding: 12px; border-radius: 8px; margin-bottom: 20px; text-align: center; border: 1px solid #c3e6cb; font-size: 14px;">
            <strong>Registrasi Berhasil!</strong><br>
            Akun Anda sudah terdaftar. Silakan login.
        </div>
    <% } %>

    <%-- NOTIFIKASI ERROR LOGIN --%>
    <% if (request.getParameter("error") != null) { %>
        <div class="error" style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center;">
            Username atau password salah!
        </div>
    <% } %>

    <form class="login-form" action="login" method="post">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button class="btn-login" type="submit">Login</button>
    </form>

    <div class="register-link">
        Belum punya akun?
        <a href="register.jsp">Daftar di sini</a>
    </div>
</div>

</body>
</html>