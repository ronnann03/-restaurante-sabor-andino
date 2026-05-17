<%@ page import="java.sql.*, util.Conexion" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Panel de Demostración – Sabor Andino</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Crimson+Pro:wght@300;400&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --rojo:    #8B1A1A;
      --rojo-claro: #b22222;
      --dorado:  #c9a84c;
      --bg:      #faf8f5;
      --txt:     #2c1a0e;
      --gris:    #f5f0eb;
      --borde:   #e8ddd0;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Crimson Pro', Georgia, serif;
      background: var(--bg);
      color: var(--txt);
      font-size: 16px;
    }

    /* ── HEADER ── */
    .header {
      background: var(--rojo);
      color: white;
      padding: 20px 40px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 12px;
    }
    .header-logo {
      font-family: 'Playfair Display', serif;
      font-size: 1.8rem;
      font-weight: 900;
      letter-spacing: 1px;
    }
    .header-logo span { color: var(--dorado); }
    .header-subtitle {
      font-size: 0.9rem;
      opacity: 0.85;
      margin-top: 2px;
    }
    .header-badge {
      background: var(--dorado);
      color: #1a0a00;
      font-family: 'Playfair Display', serif;
      font-weight: 700;
      padding: 6px 16px;
      border-radius: 20px;
      font-size: 0.85rem;
      letter-spacing: 0.5px;
    }

    /* ── LAYOUT ── */
    .container { max-width: 1200px; margin: 0 auto; padding: 32px 24px; }

    .page-title {
      font-family: 'Playfair Display', serif;
      font-size: 1.6rem;
      color: var(--rojo);
      margin-bottom: 6px;
    }
    .page-desc { color: #6b5040; font-size: 0.95rem; margin-bottom: 28px; }

    /* ── STATS ── */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
      gap: 16px;
      margin-bottom: 36px;
    }
    .stat-card {
      background: white;
      border: 1px solid var(--borde);
      border-radius: 10px;
      padding: 20px;
      text-align: center;
      box-shadow: 0 2px 8px rgba(139,26,26,.06);
    }
    .stat-num {
      font-family: 'Playfair Display', serif;
      font-size: 2.4rem;
      font-weight: 900;
      color: var(--rojo);
      line-height: 1;
    }
    .stat-label { font-size: 0.82rem; color: #7a5c40; margin-top: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
    .stat-icon  { font-size: 1.5rem; margin-bottom: 8px; }

    /* ── SECCIONES ── */
    .section {
      background: white;
      border: 1px solid var(--borde);
      border-radius: 12px;
      margin-bottom: 28px;
      box-shadow: 0 2px 10px rgba(139,26,26,.05);
      overflow: hidden;
    }
    .section-header {
      background: var(--rojo);
      color: white;
      padding: 14px 22px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 8px;
    }
    .section-title {
      font-family: 'Playfair Display', serif;
      font-size: 1.1rem;
      font-weight: 700;
    }
    .section-icon { font-size: 1.2rem; margin-right: 8px; }
    .btn-agregar {
      background: var(--dorado);
      color: #1a0a00;
      border: none;
      border-radius: 6px;
      padding: 6px 14px;
      font-family: 'Crimson Pro', serif;
      font-size: 0.9rem;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
    }
    .btn-agregar:hover { background: #e0b85a; }

    /* ── TABLA ── */
    .table-wrap { overflow-x: auto; }
    table { width: 100%; border-collapse: collapse; }
    thead th {
      background: var(--gris);
      color: var(--rojo);
      padding: 11px 16px;
      text-align: left;
      font-size: 0.82rem;
      text-transform: uppercase;
      letter-spacing: 0.6px;
      border-bottom: 2px solid var(--borde);
      white-space: nowrap;
    }
    tbody td {
      padding: 11px 16px;
      border-bottom: 1px solid var(--borde);
      font-size: 0.95rem;
      vertical-align: middle;
    }
    tbody tr:last-child td { border-bottom: none; }
    tbody tr:hover td { background: #fdf8f3; }

    /* ── BADGES ── */
    .badge {
      display: inline-block;
      padding: 2px 10px;
      border-radius: 12px;
      font-size: 0.8rem;
      font-weight: 600;
    }
    .badge-confirmada { background: #d4edda; color: #155724; }
    .badge-pendiente  { background: #fff3cd; color: #856404; }
    .badge-cancelada  { background: #f8d7da; color: #721c24; }
    .badge-disponible { background: #d4edda; color: #155724; }
    .badge-ocupada    { background: #f8d7da; color: #721c24; }
    .badge-reservada  { background: #fff3cd; color: #856404; }

    .price { color: var(--rojo); font-weight: 600; }
    .dim   { color: #999; font-style: italic; }

    /* ── ACCIONES NAV ── */
    .actions-bar {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
      margin-bottom: 28px;
    }
    .btn-nav {
      background: var(--rojo);
      color: white;
      border: none;
      border-radius: 8px;
      padding: 10px 20px;
      font-family: 'Crimson Pro', serif;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: background .2s;
    }
    .btn-nav:hover { background: var(--rojo-claro); }
    .btn-nav-outline {
      background: white;
      color: var(--rojo);
      border: 2px solid var(--rojo);
      border-radius: 8px;
      padding: 9px 20px;
      font-family: 'Crimson Pro', serif;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: all .2s;
    }
    .btn-nav-outline:hover { background: var(--rojo); color: white; }

    /* ── FOOTER ── */
    .footer {
      background: var(--rojo);
      color: rgba(255,255,255,.7);
      text-align: center;
      padding: 18px;
      font-size: 0.85rem;
      margin-top: 20px;
    }
    .footer strong { color: white; }

    /* ── ERROR ── */
    .error-row td { color: #c0392b; font-style: italic; }
  </style>
</head>
<body>

  <!-- HEADER -->
  <header class="header">
    <div>
      <div class="header-logo">Sabor <span>Andino</span></div>
      <div class="header-subtitle">Sistema de Gestión · Base de Datos Supabase / PostgreSQL</div>
    </div>
    <div class="header-badge">Avance 2 · Exposición</div>
  </header>

  <div class="container">

    <h1 class="page-title">Panel de Demostración</h1>
    <p class="page-desc">Todas las tablas de la base de datos en tiempo real desde Supabase.</p>

    <!-- BOTONES DE ACCESO RÁPIDO -->
    <div class="actions-bar">
      <a class="btn-nav" href="insertar_cliente.jsp">+ Nuevo Cliente</a>
      <a class="btn-nav" href="insertar_reserva.jsp">+ Nueva Reserva</a>
      <a class="btn-nav-outline" href="listar_clientes.jsp">Ver Clientes</a>
      <a class="btn-nav-outline" href="listar_reservas.jsp">Ver Reservas</a>
    </div>

<%
  // ── STATS ──
  int nClientes = 0, nReservas = 0, nPlatos = 0, nMesas = 0;
  try (Connection con = Conexion.getConnection()) {
      ResultSet r;
      r = con.createStatement().executeQuery("SELECT COUNT(*) FROM clientes");
      if (r.next()) nClientes = r.getInt(1);
      r = con.createStatement().executeQuery("SELECT COUNT(*) FROM reservas");
      if (r.next()) nReservas = r.getInt(1);
      r = con.createStatement().executeQuery("SELECT COUNT(*) FROM platos");
      if (r.next()) nPlatos = r.getInt(1);
      r = con.createStatement().executeQuery("SELECT COUNT(*) FROM mesas");
      if (r.next()) nMesas = r.getInt(1);
  } catch (Exception e) { /* sigue sin stats */ }
%>

    <!-- TARJETAS RESUMEN -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">👤</div>
        <div class="stat-num"><%= nClientes %></div>
        <div class="stat-label">Clientes</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">📅</div>
        <div class="stat-num"><%= nReservas %></div>
        <div class="stat-label">Reservas</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">🍽️</div>
        <div class="stat-num"><%= nPlatos %></div>
        <div class="stat-label">Platos</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">🪑</div>
        <div class="stat-num"><%= nMesas %></div>
        <div class="stat-label">Mesas</div>
      </div>
    </div>

    <!-- ══════════════════════════════════════
         TABLA 1: CLIENTES
    ══════════════════════════════════════ -->
    <div class="section">
      <div class="section-header">
        <div class="section-title"><span class="section-icon">👤</span>Clientes</div>
        <a class="btn-agregar" href="insertar_cliente.jsp">+ Agregar</a>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>ID</th><th>Nombre</th><th>Apellido</th>
              <th>Email</th><th>Teléfono</th><th>Registro</th>
            </tr>
          </thead>
          <tbody>
<%
  try (Connection con = Conexion.getConnection();
       ResultSet rs = con.createStatement().executeQuery(
           "SELECT * FROM clientes ORDER BY id")) {
      boolean vacio = true;
      while (rs.next()) {
          vacio = false;
          String tel = rs.getString("telefono");
%>
            <tr>
              <td><%= rs.getInt("id") %></td>
              <td><%= rs.getString("nombre") %></td>
              <td><%= rs.getString("apellido") %></td>
              <td><%= rs.getString("email") %></td>
              <td><%= tel != null ? tel : "<span class='dim'>—</span>" %></td>
              <td><%= rs.getTimestamp("fecha_registro").toString().substring(0,10) %></td>
            </tr>
<%    }
      if (vacio) { %><tr><td colspan="6" class="dim" style="padding:16px">Sin registros</td></tr><% }
  } catch (Exception e) { %>
            <tr class="error-row"><td colspan="6">Error: <%= e.getMessage() %></td></tr>
<% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ══════════════════════════════════════
         TABLA 2: RESERVAS (con JOIN)
    ══════════════════════════════════════ -->
    <div class="section">
      <div class="section-header">
        <div class="section-title"><span class="section-icon">📅</span>Reservas</div>
        <a class="btn-agregar" href="insertar_reserva.jsp">+ Agregar</a>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>ID</th><th>Cliente</th><th>Mesa</th><th>Ubicación</th>
              <th>Fecha</th><th>Hora</th><th>Personas</th><th>Estado</th><th>Notas</th>
            </tr>
          </thead>
          <tbody>
<%
  String sqlRes = "SELECT r.id, c.nombre||' '||c.apellido AS cliente, " +
                  "m.numero, m.ubicacion, r.fecha_reserva, r.hora_reserva, " +
                  "r.num_personas, r.estado, r.notas " +
                  "FROM reservas r " +
                  "JOIN clientes c ON r.cliente_id = c.id " +
                  "JOIN mesas    m ON r.mesa_id    = m.id " +
                  "ORDER BY r.fecha_reserva, r.hora_reserva";
  try (Connection con = Conexion.getConnection();
       ResultSet rs = con.createStatement().executeQuery(sqlRes)) {
      boolean vacio = true;
      while (rs.next()) {
          vacio = false;
          String estado  = rs.getString("estado");
          String notas   = rs.getString("notas");
%>
            <tr>
              <td><%= rs.getInt("id") %></td>
              <td><%= rs.getString("cliente") %></td>
              <td>Mesa <%= rs.getInt("numero") %></td>
              <td><%= rs.getString("ubicacion") %></td>
              <td><%= rs.getDate("fecha_reserva") %></td>
              <td><%= rs.getTime("hora_reserva").toString().substring(0,5) %></td>
              <td><%= rs.getInt("num_personas") %></td>
              <td><span class="badge badge-<%= estado %>"><%= estado %></span></td>
              <td><%= notas != null ? notas : "<span class='dim'>—</span>" %></td>
            </tr>
<%    }
      if (vacio) { %><tr><td colspan="9" class="dim" style="padding:16px">Sin registros</td></tr><% }
  } catch (Exception e) { %>
            <tr class="error-row"><td colspan="9">Error: <%= e.getMessage() %></td></tr>
<% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ══════════════════════════════════════
         TABLA 3: PLATOS
    ══════════════════════════════════════ -->
    <div class="section">
      <div class="section-header">
        <div class="section-title"><span class="section-icon">🍽️</span>Platos</div>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>ID</th><th>Categoría</th><th>Nombre</th>
              <th>Descripción</th><th>Precio</th><th>Disponible</th>
            </tr>
          </thead>
          <tbody>
<%
  String sqlPlatos = "SELECT p.id, c.nombre AS cat, p.nombre, p.descripcion, p.precio, p.disponible " +
                     "FROM platos p LEFT JOIN categorias c ON p.categoria_id = c.id ORDER BY p.id";
  try (Connection con = Conexion.getConnection();
       ResultSet rs = con.createStatement().executeQuery(sqlPlatos)) {
      boolean vacio = true;
      while (rs.next()) {
          vacio = false;
%>
            <tr>
              <td><%= rs.getInt("id") %></td>
              <td><%= rs.getString("cat") %></td>
              <td><%= rs.getString("nombre") %></td>
              <td><%= rs.getString("descripcion") %></td>
              <td class="price">S/ <%= rs.getBigDecimal("precio").toPlainString() %></td>
              <td>
                <span class="badge <%= rs.getBoolean("disponible") ? "badge-confirmada" : "badge-cancelada" %>">
                  <%= rs.getBoolean("disponible") ? "Sí" : "No" %>
                </span>
              </td>
            </tr>
<%    }
      if (vacio) { %><tr><td colspan="6" class="dim" style="padding:16px">Sin registros</td></tr><% }
  } catch (Exception e) { %>
            <tr class="error-row"><td colspan="6">Error: <%= e.getMessage() %></td></tr>
<% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ══════════════════════════════════════
         TABLA 4: MESAS
    ══════════════════════════════════════ -->
    <div class="section">
      <div class="section-header">
        <div class="section-title"><span class="section-icon">🪑</span>Mesas</div>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>ID</th><th>Número</th><th>Capacidad</th><th>Ubicación</th><th>Estado</th>
            </tr>
          </thead>
          <tbody>
<%
  try (Connection con = Conexion.getConnection();
       ResultSet rs = con.createStatement().executeQuery(
           "SELECT * FROM mesas ORDER BY numero")) {
      boolean vacio = true;
      while (rs.next()) {
          vacio = false;
          String est = rs.getString("estado");
%>
            <tr>
              <td><%= rs.getInt("id") %></td>
              <td><strong>Mesa <%= rs.getInt("numero") %></strong></td>
              <td><%= rs.getInt("capacidad") %> personas</td>
              <td><%= rs.getString("ubicacion") %></td>
              <td><span class="badge badge-<%= est %>"><%= est %></span></td>
            </tr>
<%    }
      if (vacio) { %><tr><td colspan="5" class="dim" style="padding:16px">Sin registros</td></tr><% }
  } catch (Exception e) { %>
            <tr class="error-row"><td colspan="5">Error: <%= e.getMessage() %></td></tr>
<% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ══════════════════════════════════════
         TABLA 5: CATEGORÍAS
    ══════════════════════════════════════ -->
    <div class="section">
      <div class="section-header">
        <div class="section-title"><span class="section-icon">📂</span>Categorías</div>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr><th>ID</th><th>Nombre</th><th>Descripción</th></tr>
          </thead>
          <tbody>
<%
  try (Connection con = Conexion.getConnection();
       ResultSet rs = con.createStatement().executeQuery(
           "SELECT * FROM categorias ORDER BY id")) {
      boolean vacio = true;
      while (rs.next()) {
          vacio = false;
          String desc = rs.getString("descripcion");
%>
            <tr>
              <td><%= rs.getInt("id") %></td>
              <td><%= rs.getString("nombre") %></td>
              <td><%= desc != null ? desc : "<span class='dim'>—</span>" %></td>
            </tr>
<%    }
      if (vacio) { %><tr><td colspan="3" class="dim" style="padding:16px">Sin registros</td></tr><% }
  } catch (Exception e) { %>
            <tr class="error-row"><td colspan="3">Error: <%= e.getMessage() %></td></tr>
<% } %>
          </tbody>
        </table>
      </div>
    </div>

  </div><!-- /container -->

  <footer class="footer">
    <strong>Sabor Andino</strong> &nbsp;·&nbsp; Base de datos: <strong>Supabase / PostgreSQL</strong>
    &nbsp;·&nbsp; Avance 2 &nbsp;·&nbsp; 2025
  </footer>

</body>
</html>
