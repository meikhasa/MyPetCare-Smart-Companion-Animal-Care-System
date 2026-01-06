<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register | MyPetCare</title>
    <link rel="stylesheet" href="css/register.css">
</head>
<body class="register-body">

<div class="register-container">
    <h2>Daftar Akun</h2>

    <form action="<%=request.getContextPath()%>/register" method="post" class="register-form">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="password" name="confirmPassword" placeholder="Konfirmasi Password" required>

        <select name="role" required>
            <option value="">-- Pilih Jenis Akun --</option>
            <option value="owner">Pemilik Hewan</option>
            <option value="vet">Dokter Hewan / Klinik</option>
        </select>

        <button type="submit" class="btn-register">Daftar</button>
    </form>

    <p class="login-link">
        Sudah punya akun? <a href="login.jsp">Login</a>
    </p>
</div>

</body>
</html>