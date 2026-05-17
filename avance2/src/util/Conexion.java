package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {

    // -------------------------------------------------------
    //  Reemplaza estos tres valores con los de tu proyecto
    //  Supabase: Settings > Database > Connection string
    // -------------------------------------------------------
    private static final String HOST = "db.XXXXXXXXXXXXXXXX.supabase.co";
    private static final String URL  = "jdbc:postgresql://" + HOST + ":5432/postgres";
    private static final String USER = "postgres";
    private static final String PASS = "TU_PASSWORD_SUPABASE";

    public static Connection getConnection() throws Exception {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
