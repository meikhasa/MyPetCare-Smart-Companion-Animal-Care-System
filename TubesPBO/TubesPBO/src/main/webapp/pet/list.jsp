<%-- 
    Document   : list
    Created on : Dec 16, 2025, 12:43:33?AM
    Author     : achma
--%>

<%@page import="java.sql.*"%>
<%
    ResultSet rs = (ResultSet) request.getAttribute("rs");
%>

<table class="table">
    <tr>
        <th>Photo</th>
        <th>Nama</th>
        <th>Jenis</th>
        <th>Ras</th>
        <th>Usia</th>
    </tr>

    <% while (rs.next()) {%>
    <tr>
        <td>
            <img src="<%=request.getContextPath()%>/uploads/<%=rs.getString("foto")%>"
                 width="80">
        </td>
        <td><%=rs.getString("nama")%></td>
        <td><%=rs.getString("jenis")%></td>
        <td><%=rs.getString("ras")%></td>
        <td><%=rs.getInt("usia")%> tahun</td>
    </tr>
    <% }%>
</table>

<br>
<a href="../dashboard-owner.jsp">? Kembali ke Dashboard</a>
</div>

</body>
</html>
