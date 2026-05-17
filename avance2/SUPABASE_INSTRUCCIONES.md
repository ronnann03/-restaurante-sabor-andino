# Sabor Andino — Avance 2: Base de Datos en Supabase

## Estructura de archivos

```
avance2/
├── database/
│   └── sabor_andino.sql        ← SQL para crear tablas e insertar datos
├── src/
│   └── util/
│       └── Conexion.java       ← Clase de conexión JDBC
├── web/
│   ├── insertar_cliente.jsp    ← Formulario para insertar clientes
│   ├── insertar_reserva.jsp    ← Formulario para insertar reservas
│   ├── listar_clientes.jsp     ← Tabla con todos los clientes
│   └── listar_reservas.jsp     ← Tabla con todas las reservas (JOIN)
└── SUPABASE_INSTRUCCIONES.md   ← Este archivo
```

---

## Diagrama Entidad-Relación (5 tablas)

```
┌─────────────────────┐          ┌──────────────────────────┐
│      CATEGORIAS      │          │          PLATOS           │
├─────────────────────┤          ├──────────────────────────┤
│ PK  id     SERIAL   │1       N │ PK  id          SERIAL   │
│     nombre VARCHAR  │──────────│ FK  categoria_id INT      │
│     descripcion TEXT│          │     nombre      VARCHAR   │
└─────────────────────┘          │     descripcion TEXT      │
                                 │     precio      NUMERIC   │
                                 │     disponible  BOOLEAN   │
                                 └──────────────────────────┘

┌──────────────────────────┐          ┌───────────────────────────┐
│         CLIENTES          │          │          RESERVAS          │
├──────────────────────────┤          ├───────────────────────────┤
│ PK  id             SERIAL│1       N │ PK  id            SERIAL  │
│     nombre         VARCHAR│─────────│ FK  cliente_id    INT     │
│     apellido       VARCHAR│         │ FK  mesa_id       INT     │
│     email          VARCHAR│         │     fecha_reserva DATE    │
│     telefono       VARCHAR│         │     hora_reserva  TIME    │
│     fecha_registro TIMESTAMP        │     num_personas  INT     │
└──────────────────────────┘         │     estado        VARCHAR │
                                      │     notas         TEXT    │
┌────────────────────────┐     N      │     fecha_creacion TIMESTAMP│
│          MESAS          │────────────└───────────────────────────┘
├────────────────────────┤  1
│ PK  id        SERIAL   │
│     numero    INT      │
│     capacidad INT      │
│     ubicacion VARCHAR  │
│     estado    VARCHAR  │
└────────────────────────┘
```

### Cardinalidades

| Relación                    | Tipo  | Descripción                                  |
|-----------------------------|-------|----------------------------------------------|
| `categorias` → `platos`     | 1 : N | Una categoría tiene muchos platos            |
| `clientes`   → `reservas`   | 1 : N | Un cliente puede tener muchas reservas       |
| `mesas`      → `reservas`   | 1 : N | Una mesa puede tener muchas reservas         |

### Claves foráneas

| Tabla      | FK             | Referencia          | On Delete    |
|------------|----------------|---------------------|--------------|
| `platos`   | `categoria_id` | `categorias(id)`    | SET NULL     |
| `reservas` | `cliente_id`   | `clientes(id)`      | CASCADE      |
| `reservas` | `mesa_id`      | `mesas(id)`         | SET NULL     |

---

## PASO 1 — Crear proyecto en Supabase

1. Entra a **https://supabase.com** e inicia sesión
2. Clic en **"New project"**
3. Completa el formulario:
   - **Name:** `sabor-andino`
   - **Database Password:** escribe una contraseña segura y **guárdala**
   - **Region:** `South America (São Paulo)`
4. Clic en **"Create new project"**
5. Espera ~2 minutos hasta que el proyecto esté listo

---

## PASO 2 — Crear las tablas (SQL Editor)

1. En el menú izquierdo clic en **"SQL Editor"**
2. Clic en **"New query"**
3. Abre el archivo `database/sabor_andino.sql` y **copia todo su contenido**
4. Pégalo en el editor de Supabase
5. Clic en **"Run"** (o `Ctrl + Enter`)
6. Debe aparecer: `Success. No rows returned`

> **Evidencia para el profesor:** ve a **"Table Editor"** en el menú izquierdo.  
> Deben aparecer las 5 tablas: `categorias`, `platos`, `clientes`, `mesas`, `reservas`.  
> Toma una **captura de pantalla** de esa pantalla.

---

## PASO 3 — Obtener los datos de conexión JDBC

1. En Supabase ve a: **Project Settings** (ícono de engranaje) → **Database**
2. Baja hasta la sección **"Connection string"**
3. Selecciona la pestaña **"URI"**
4. Verás algo así:

```
postgresql://postgres:[YOUR-PASSWORD]@db.xxxxxxxxxxxxxxxx.supabase.co:5432/postgres
```

Anota los siguientes datos:

| Campo    | Valor                                        |
|----------|----------------------------------------------|
| Host     | `db.xxxxxxxxxxxxxxxx.supabase.co`            |
| Puerto   | `5432`                                       |
| Base de datos | `postgres`                              |
| Usuario  | `postgres`                                   |
| Password | la contraseña que pusiste al crear el proyecto |

---

## PASO 4 — Configurar Conexion.java

Abre el archivo `src/util/Conexion.java` y reemplaza los valores:

```java
private static final String HOST = "db.XXXXXXXXXXXXXXXX.supabase.co";  // ← tu host
private static final String PASS = "TU_PASSWORD_SUPABASE";              // ← tu contraseña
```

Ejemplo real (no uses estos datos, son de ejemplo):
```java
private static final String HOST = "db.abcdefghijklmno.supabase.co";
private static final String PASS = "MiPassword123!";
```

---

## PASO 5 — Descargar el driver PostgreSQL JDBC

El driver JDBC permite que Java se conecte a PostgreSQL (Supabase).

1. Ve a: **https://jdbc.postgresql.org/download/**
2. Descarga: `postgresql-42.7.4.jar`
3. En NetBeans, copia ese `.jar` dentro de tu proyecto en:
   ```
   NombreProyecto/
   └── web/
       └── WEB-INF/
           └── lib/
               └── postgresql-42.7.4.jar   ← aquí
   ```
4. En NetBeans: clic derecho en el proyecto → **Properties** → **Libraries** → **Add JAR/Folder** → selecciona el `.jar`

---

## PASO 6 — Crear el proyecto en NetBeans

1. Abre NetBeans
2. **File → New Project → Java with Ant → Java Web → Web Application**
3. Nombre del proyecto: `SaborAndino`
4. Server: **Apache Tomcat** (versión que trae NetBeans)
5. Clic en **Finish**

### Agregar los archivos al proyecto

| Archivo fuente              | Destino en NetBeans                     |
|-----------------------------|-----------------------------------------|
| `src/util/Conexion.java`    | `Source Packages → util → Conexion.java` |
| `web/insertar_cliente.jsp`  | `Web Pages → insertar_cliente.jsp`      |
| `web/insertar_reserva.jsp`  | `Web Pages → insertar_reserva.jsp`      |
| `web/listar_clientes.jsp`   | `Web Pages → listar_clientes.jsp`       |
| `web/listar_reservas.jsp`   | `Web Pages → listar_reservas.jsp`       |
| `postgresql-42.7.4.jar`     | `WEB-INF/lib/`                          |

---

## PASO 7 — Ejecutar el proyecto

1. Clic derecho en el proyecto → **Run** (o `F6`)
2. El navegador abrirá `http://localhost:8080/SaborAndino/`
3. Navega a las páginas:

| URL                                                      | Función                |
|----------------------------------------------------------|------------------------|
| `http://localhost:8080/SaborAndino/insertar_cliente.jsp` | Insertar un cliente    |
| `http://localhost:8080/SaborAndino/insertar_reserva.jsp` | Insertar una reserva   |
| `http://localhost:8080/SaborAndino/listar_clientes.jsp`  | Listar todos los clientes |
| `http://localhost:8080/SaborAndino/listar_reservas.jsp`  | Listar todas las reservas |

---

## Verificar datos en Supabase

Después de insertar datos desde JSP, puedes verlos en Supabase:

1. Ve a **Table Editor** en Supabase
2. Selecciona la tabla `clientes` o `reservas`
3. Los datos insertados desde JSP aparecerán ahí en tiempo real

---

## Resumen del Avance 2

| Requisito del Profesor          | Archivo / Evidencia                                |
|---------------------------------|----------------------------------------------------|
| Modelo ER (mínimo 5 tablas)     | Diagrama en este documento + captura de Supabase   |
| BD creada en motor real         | Captura del Table Editor de Supabase               |
| Programa insertar (tabla 1)     | `insertar_cliente.jsp` + `Conexion.java`           |
| Programa insertar (tabla 2)     | `insertar_reserva.jsp` + `Conexion.java`           |
| Programa listar (tabla 1)       | `listar_clientes.jsp`                              |
| Programa listar (tabla 2)       | `listar_reservas.jsp` (con JOIN a clientes y mesas)|

---

## Errores comunes

| Error                                  | Solución                                                    |
|----------------------------------------|-------------------------------------------------------------|
| `Connection refused`                   | Verifica que el HOST en `Conexion.java` sea correcto        |
| `password authentication failed`       | Verifica la contraseña en `Conexion.java`                   |
| `ClassNotFoundException: org.postgresql` | El `.jar` no está en `WEB-INF/lib/` o no fue agregado a Libraries |
| `duplicate key value (email)`          | Ya existe un cliente con ese email en la BD                 |
| Página en blanco                       | Revisa la consola de NetBeans por errores de compilación    |
