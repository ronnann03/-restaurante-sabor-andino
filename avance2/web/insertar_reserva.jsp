<%@ page import="java.sql.*, util.Conexion" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <title>Nueva Reserva - Sabor Andino</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 500px; margin: 40px auto; padding: 0 20px; }
    h2   { color: #8B1A1A; }
    label { display: block; margin-top: 12px; font-weight: bold; }
    input, select, textarea {
      width: 100%; padding: 8px; margin-top: 4px;
      border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
    }
    button { margin-top: 20px; padding: 10px 24px; background: #8B1A1A;
             color: white; border: none; border-radius: 4px; cursor: pointer; }
    .ok  { color: green; margin-top: 14px; }
    .err { color: red;   margin-top: 14px; }
  </style>
</head>
<body>
  <h2>Registrar Nueva Reserva</h2>

  <!-- Selector dinámico de clientes -->
  <form method="post" action="insertar_reserva.jsp">
    <label>Cliente</label>
    <select name="cliente_id" required>
      <option value="">-- Selecciona un cliente --</option>
<%
  try (Connection con = Conexion.getConnection();
       Statement st  = con.createStatement();
       ResultSet rs  = st.executeQuery("SELECT id, nombre, apellido FROM clientes ORDER BY nombre")) {
      while (rs.next()) {
%>
      <option value="<%= rs.getInt("id") %>">
        <%= rs.getString("nombre") %> <%= rs.getString("apellido") %>
      </option>
<%
      }
  } catch (Exception e) { out.println("<option>Error cargando clientes</option>"); }
%>
    </select>

    <label>Mesa</label>
    <select name="mesa_id" required>
      <option value="">-- Selecciona una mesa --</option>
<%
  try (Connection con = Conexion.getConnection();
       Statement st  = con.createStatement();
       ResultSet rs  = st.executeQuery("SELECT id, numero, capacidad, ubicacion FROM mesas ORDER BY numero")) {
      while (rs.next()) {
%>
      <option value="<%= rs.getInt("id") %>">
        Mesa <%= rs.getInt("numero") %> · <%= rs.getInt("capacidad") %> personas · <%= rs.getString("ubicacion") %>
      </option>
<%
      }
  } catch (Exception e) { out.println("<option>Error cargando mesas</option>"); }
%>
    </select>

    <label>Fecha de Reserva</label>
    <input type="date" name="fecha" required/>

    <label>Hora</label>
    <input type="time" name="hora"  required/>

    <label>Número de Personas</label>
    <input type="number" name="num_personas" min="1" max="20" required/>

    <label>Notas adicionales</label>
    <textarea name="notas" rows="3" placeholder="Opcional..."></textarea>

    <button type="submit">Confirmar Reserva</button>
  </form>

<%
  if ("POST".equals(request.getMethod())) {
      try (Connection con = Conexion.getConnection()) {
          String sql = "INSERT INTO reservas " +
                       "(cliente_id, mesa_id, fecha_reserva, hora_reserva, num_personas, notas) " +
                       "VALUES (?,?,?,?,?,?)";
          PreparedStatement ps = con.prepareStatement(sql);
          ps.setInt(1,    Integer.parseInt(request.getParameter("cliente_id")));
          ps.setInt(2,    Integer.parseInt(request.getParameter("mesa_id")));
          ps.setDate(3,   java.sql.Date.valueOf(request.getParameter("fecha")));
          ps.setTime(4,   java.sql.Time.valueOf(request.getParameter("hora") + ":00"));
          ps.setInt(5,    Integer.parseInt(request.getParameter("num_personas")));
          ps.setString(6, request.getParameter("notas"));
          ps.executeUpdate();
%>
  <p class="ok"><strong>Reserva registrada correctamente.</strong></p>
<%
      } catch (Exception e) {
%>
  <p class="err">Error al registrar: <%= e.getMessage() %></p>
<%
      }
  }
%>

  <p><a href="listar_reservas.jsp">Ver todas las reservas</a></p>
</body>
</html>
