<<<<<<< Updated upstream
package dal;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author FPT University - PRJ30X
 */
public class DBContext {

    protected Connection connection;

    public DBContext() {
        try {
            // Load database configuration from properties file
            Properties props = new Properties();
            InputStream input = getClass().getClassLoader().getResourceAsStream("ConnectDB.properties");
            if (input == null) {
                // Fallback: try loading from WEB-INF
                input = getClass().getClassLoader().getResourceAsStream("/WEB-INF/ConnectDB.properties");
            }
            
            if (input != null) {
                props.load(input);
                input.close();
            } else {
                // Fallback to default values if properties file not found
                Logger.getLogger(DBContext.class.getName()).log(Level.WARNING, "ConnectDB.properties not found, using default values");
            }
            
            String url = props.getProperty("url", "jdbc:sqlserver://localhost:1433;databaseName=PHMS_DB;encrypt=true;trustServerCertificate=true;");
            String user = props.getProperty("userID", "sa");
            String pass = props.getProperty("password", "123");
            
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
            if (connection != null) {
                System.out.println("Database connection established successfully!");
            } else {
                System.out.println("Database connection is null!");
            }
        } catch (ClassNotFoundException ex) {
            System.out.println("JDBC Driver not found: " + ex.getMessage());
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException ex) {
            System.out.println("Database connection failed: " + ex.getMessage());
            System.out.println("SQL State: " + ex.getSQLState());
            System.out.println("Error Code: " + ex.getErrorCode());
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Database connection failed", ex);
        } catch (Exception ex) {
            System.out.println("Error loading properties: " + ex.getMessage());
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error loading properties", ex);
        }
    }
    
}
=======
package dal;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author FPT University - PRJ30X
 */
public class DBContext {

    protected Connection connection;

    public DBContext() {
        try {
            // Load database configuration from properties file
            Properties props = new Properties();
            InputStream input = getClass().getClassLoader().getResourceAsStream("ConnectDB.properties");
            if (input == null) {
                // Fallback: try loading from WEB-INF
                input = getClass().getClassLoader().getResourceAsStream("/WEB-INF/ConnectDB.properties");
            }
            
            if (input != null) {
                props.load(input);
                input.close();
            } else {
                // Fallback to default values if properties file not found
                Logger.getLogger(DBContext.class.getName()).log(Level.WARNING, "ConnectDB.properties not found, using default values");
            }
            
            String url = props.getProperty("url", "jdbc:sqlserver://localhost:1433;databaseName=PHMS_DB;encrypt=true;trustServerCertificate=true;");
            String user = props.getProperty("userID", "sa");
            String pass = props.getProperty("password", "123");
            
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
            if (connection != null) {
                System.out.println("Database connection established successfully!");
            } else {
                System.out.println("Database connection is null!");
            }
        } catch (ClassNotFoundException ex) {
            System.out.println("JDBC Driver not found: " + ex.getMessage());
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException ex) {
            System.out.println("Database connection failed: " + ex.getMessage());
            System.out.println("SQL State: " + ex.getSQLState());
            System.out.println("Error Code: " + ex.getErrorCode());
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Database connection failed", ex);
        } catch (Exception ex) {
            System.out.println("Error loading properties: " + ex.getMessage());
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error loading properties", ex);
        }
    }
    
}
>>>>>>> Stashed changes
