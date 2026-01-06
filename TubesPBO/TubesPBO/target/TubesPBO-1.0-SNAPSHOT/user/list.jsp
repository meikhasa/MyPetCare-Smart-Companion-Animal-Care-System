<%-- 
    Document   : list
    Created on : Dec 16, 2025, 12:42:39?AM
    Author     : achma
--%>

<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Data User</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<h2>Data User</h2>

<a href="user?action=add" class="btn">Tambah User</a>
<table border="1" cellpadding="10">
    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Role</th>
        <th>Aksi</th>
    </tr>

<%
    ResultSet rs = (ResultSet) request.getAttribute("users");
    while (rs != null && rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("username") %></td>
        <td><%= rs.getString("role") %></td>
        <td>
            <a href="user?action=edit&id=<%= rs.getInt("id") %>">Edit</a> |
            <a href="user?action=delete&id=<%= rs.getInt("id") %>">Hapus</a>
        </td>
    </tr>
<% } %>

</table>
</body>
</html>
