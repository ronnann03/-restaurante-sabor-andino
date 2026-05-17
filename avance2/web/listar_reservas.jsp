<%@ page import="java.sql.*, util.Conexion" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <title>Reservas - Sabor Andino</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 1000px; margin: 40px auto; padding: 0 20px; }
    h2   { color: #8B1A1A; }
    table { width: 100%; border-collapse: collapse; margin-top: 16px; }
    th { background: #8B1A1A; color: white; padding: 10px; text-align: left; }
    td { padding: 9px 10px; border-bottom: 1px solid #ddd; }
    tr:hover td { background: #fdf5f5; }
    .estado-confirmada { color: green;  font-weight: bold; }
    .estado-pendiente  { color: orange; font-weight: bold; }
    .estado-cancelada  { color: red;    font-weight: bold; }
    .btn { display: inline-block; margin-top: 16px; padding: 9px 20px;
           background: #8B1A1A; color: white; text-decoration: none; border-radius: 4px; }
    .total { margin-top: 10px; color: #555; font-size: 0.9em; }
  </style>
</head>
<body>
  <h2>Lista de Reservas</h2>
  <a class="btn" href="insertar_reserva.jsp">+ Nueva Reserva</a>

  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Cliente</th>
        <th>Mesa</th>
        <th>Ubicación</th>
        <th>Fecha</th>
        <th>Hora</th>
        <th>Personas</th>
        <th>Estado</th>
        <th>Notas</th>
      </tr>
    </thead>
    <tbody>
<%
  int total = 0;
  String sql = "SELECT r.id, " +
               "       c.nombre || ' ' || c.apellido AS cliente, " +
               "       m.numero   AS num_mesa, " +
               "       m.ubicacion, " +
               "       r.fecha_reserva, " +
               "       r.hora_reserva, " +
               "       r.num_personas, " +
               "       r.estado, " +
               "       r.notas " +
               "FROM   reservas r " +
               "JOIN   clientes c ON r.cliente_id = c.id " +
               "JOIN   mesas    m ON r.mesa_id    = m.id " +
               "ORDER  BY r.fecha_reserva, r.hora_reserva";

  try (Connection con = Conexion.getConnection();
       Statement  st  = con.createStatement();
       ResultSet  rs  = st.executeQuery(sql)) {

      while (rs.next()) {
          total++;
          String estado = rs.getString("estado");
          String cssEstado = "estado-" + estado;
%>
      <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("cliente") %></td>
        <td>Mesa <%= rs.getInt("num_mesa") %></td>
        <td><%= rs.getString("ubicacion") %></td>
        <td><%= rs.getDate("fecha_reserva") %></td>
        <td><%= rs.getTime("hora_reserva") %></td>
        <td><%= rs.getInt("num_personas") %></td>
        <td class="<%= cssEstado %>"><%= estado %></td>
        <td><%= rs.getString("notas") != null ? rs.getString("notas") : "-" %></td>
      </tr>
<%
      }
  } catch (Exception e) {
%>
      <tr><td colspan="9" style="color:red">Error: <%= e.getMessage() %></td></tr>
<%
  }
%>
    </tbody>
  </table>

  <p class="total">Total de reservas: <strong><%= total %></strong></p>
</body>
</html>
