<%-- 
    Document   : edit
    Created on : Dec 16, 2025, 12:42:57?AM
    Author     : achma
--%>

<%@ page import="java.sql.*" %>
<%
    ResultSet rs = (ResultSet) request.getAttribute("user");
    rs.next();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
</head>
<body>
<h2>Edit User</h2>

<form action="../user" method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">

    Username: <input type="text" name="username" value="<%= rs.getString("username") %>"><br><br>
    Password: <input type="password" name="password" value="<%= rs.getString("password") %>"><br><br>

    Role:
    <select name="role">
        <option value="admin" <%= rs.getString("role").equals("admin") ? "selected":"" %>>Admin</option>
        <option value="owner" <%= rs.getString("role").equals("owner") ? "selected":"" %>>Owner</option>
        <option value="vet" <%= rs.getString("role").equals("vet") ? "selected":"" %>>Vet</option>
    </select>
    <br><br>

    <button type="submit">Update</button>
</form>

</body>
</html>
