-- ============================================================
--  RESTAURANTE SABOR ANDINO  |  Base de Datos - Avance 2
--  Motor: PostgreSQL (Supabase)
--  Tablas: categorias, platos, clientes, mesas, reservas
-- ============================================================

-- Tabla 1: categorias
CREATE TABLE IF NOT EXISTS categorias (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla 2: platos
CREATE TABLE IF NOT EXISTS platos (
    id           SERIAL PRIMARY KEY,
    categoria_id INT REFERENCES categorias(id) ON DELETE SET NULL,
    nombre       VARCHAR(100) NOT NULL,
    descripcion  TEXT,
    precio       NUMERIC(8,2) NOT NULL,
    disponible   BOOLEAN DEFAULT TRUE
);

-- Tabla 3: clientes
CREATE TABLE IF NOT EXISTS clientes (
    id              SERIAL PRIMARY KEY,
    nombre          VARCHAR(60)  NOT NULL,
    apellido        VARCHAR(60)  NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    telefono        VARCHAR(15),
    fecha_registro  TIMESTAMP DEFAULT NOW()
);

-- Tabla 4: mesas
CREATE TABLE IF NOT EXISTS mesas (
    id         SERIAL PRIMARY KEY,
    numero     INT         NOT NULL UNIQUE,
    capacidad  INT         NOT NULL,
    ubicacion  VARCHAR(30) DEFAULT 'interior',
    estado     VARCHAR(20) DEFAULT 'disponible'
);

-- Tabla 5: reservas
CREATE TABLE IF NOT EXISTS reservas (
    id             SERIAL PRIMARY KEY,
    cliente_id     INT REFERENCES clientes(id) ON DELETE CASCADE,
    mesa_id        INT REFERENCES mesas(id)    ON DELETE SET NULL,
    fecha_reserva  DATE NOT NULL,
    hora_reserva   TIME NOT NULL,
    num_personas   INT  NOT NULL,
    estado         VARCHAR(20) DEFAULT 'pendiente',
    notas          TEXT,
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

-- ============================================================
--  DATOS DE EJEMPLO
-- ============================================================

INSERT INTO categorias (nombre, descripcion) VALUES
  ('Entradas',  'Platos de entrada de la cocina peruana'),
  ('Fondos',    'Platos principales y de fondo'),
  ('Postres',   'Dulces y postres tradicionales'),
  ('Bebidas',   'Bebidas tradicionales e importadas');

INSERT INTO platos (categoria_id, nombre, descripcion, precio) VALUES
  (1, 'Ceviche Clásico',  'Pescado fresco marinado en limón con ají limo',   38.00),
  (1, 'Causa Limeña',     'Masa de papa amarilla rellena de pollo',           28.00),
  (2, 'Lomo Saltado',     'Lomo fino salteado con verduras y papas fritas',   52.00),
  (2, 'Ají de Gallina',   'Pollo en salsa cremosa de ají amarillo y nueces',  42.00),
  (3, 'Suspiro Limeño',   'Dulce de leche con merengue italiano',             22.00),
  (4, 'Chicha Morada',    'Bebida tradicional de maíz morado',                12.00);

INSERT INTO mesas (numero, capacidad, ubicacion) VALUES
  (1, 2, 'interior'),
  (2, 4, 'interior'),
  (3, 4, 'terraza'),
  (4, 6, 'terraza'),
  (5, 8, 'salón privado');

INSERT INTO clientes (nombre, apellido, email, telefono) VALUES
  ('María',  'Fernández', 'maria.fernandez@email.com', '987654321'),
  ('Carlos', 'Rojas',     'carlos.rojas@email.com',    '912345678'),
  ('Ana',    'Torres',    'ana.torres@email.com',      '945678123');

INSERT INTO reservas (cliente_id, mesa_id, fecha_reserva, hora_reserva, num_personas, estado) VALUES
  (1, 2, '2025-05-15', '13:00', 3, 'confirmada'),
  (2, 4, '2025-05-16', '19:30', 5, 'pendiente'),
  (3, 1, '2025-05-17', '20:00', 2, 'confirmada');

-- ============================================================
--  ACCESO ANÓNIMO (necesario para el cliente JS de Supabase)
--  Deshabilita RLS en todas las tablas del proyecto
-- ============================================================
ALTER TABLE categorias DISABLE ROW LEVEL SECURITY;
ALTER TABLE platos     DISABLE ROW LEVEL SECURITY;
ALTER TABLE clientes   DISABLE ROW LEVEL SECURITY;
ALTER TABLE mesas      DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservas   DISABLE ROW LEVEL SECURITY;
