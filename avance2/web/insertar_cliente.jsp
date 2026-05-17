<%@ page import="java.sql.*, util.Conexion" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <title>Insertar Cliente - Sabor Andino</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 500px; margin: 40px auto; padding: 0 20px; }
    h2   { color: #8B1A1A; }
    label { display: block; margin-top: 12px; font-weight: bold; }
    input[type=text], input[type=email] {
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
  <h2>Registrar Nuevo Cliente</h2>

  <form method="post" action="insertar_cliente.jsp">
    <label>Nombre</label>
    <input type="text"  name="nombre"   required/>

    <label>Apellido</label>
    <input type="text"  name="apellido" required/>

    <label>Email</label>
    <input type="email" name="email"    required/>

    <label>Teléfono</label>
    <input type="text"  name="telefono"/>

    <button type="submit">Registrar Cliente</button>
  </form>

<%
  if ("POST".equals(request.getMethod())) {
      String nombre   = request.getParameter("nombre");
      String apellido = request.getParameter("apellido");
      String email    = request.getParameter("email");
      String telefono = request.getParameter("telefono");

      try (Connection con = Conexion.getConnection()) {
          String sql = "INSERT INTO clientes (nombre, apellido, email, telefono) VALUES (?,?,?,?)";
          PreparedStatement ps = con.prepareStatement(sql);
          ps.setString(1, nombre);
          ps.setString(2, apellido);
          ps.setString(3, email);
          ps.setString(4, telefono);
          ps.executeUpdate();
%>
  <p class="ok"><strong>Cliente registrado correctamente.</strong></p>
<%
      } catch (Exception e) {
%>
  <p class="err">Error al registrar: <%= e.getMessage() %></p>
<%
      }
  }
%>

  <p><a href="listar_clientes.jsp">Ver todos los clientes</a></p>
</body>
</html>
