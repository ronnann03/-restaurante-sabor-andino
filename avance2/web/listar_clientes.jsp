<%@ page import="java.sql.*, util.Conexion" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <title>Clientes - Sabor Andino</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 900px; margin: 40px auto; padding: 0 20px; }
    h2   { color: #8B1A1A; }
    table { width: 100%; border-collapse: collapse; margin-top: 16px; }
    th { background: #8B1A1A; color: white; padding: 10px; text-align: left; }
    td { padding: 9px 10px; border-bottom: 1px solid #ddd; }
    tr:hover td { background: #fdf5f5; }
    .btn { display: inline-block; margin-top: 16px; padding: 9px 20px;
           background: #8B1A1A; color: white; text-decoration: none; border-radius: 4px; }
    .total { margin-top: 10px; color: #555; font-size: 0.9em; }
  </style>
</head>
<body>
  <h2>Lista de Clientes Registrados</h2>
  <a class="btn" href="insertar_cliente.jsp">+ Nuevo Cliente</a>

  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Nombre</th>
        <th>Apellido</th>
        <th>Email</th>
        <th>Teléfono</th>
        <th>Fecha Registro</th>
      </tr>
    </thead>
    <tbody>
<%
  int total = 0;
  try (Connection con = Conexion.getConnection();
       Statement  st  = con.createStatement();
       ResultSet  rs  = st.executeQuery("SELECT * FROM clientes ORDER BY id")) {

      while (rs.next()) {
          total++;
%>
      <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("nombre") %></td>
        <td><%= rs.getString("apellido") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("telefono") != null ? rs.getString("telefono") : "-" %></td>
        <td><%= rs.getTimestamp("fecha_registro") %></td>
      </tr>
<%
      }
  } catch (Exception e) {
%>
      <tr><td colspan="6" style="color:red">Error: <%= e.getMessage() %></td></tr>
<%
  }
%>
    </tbody>
  </table>

  <p class="total">Total de clientes: <strong><%= total %></strong></p>
</body>
</html>
