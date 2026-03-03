/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author quag
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            String user = "sa";
            String pass = "123456aA@$"; 
            String url = "jdbc:sqlserver://localhost:1433;databaseName=PHMS_DB;encrypt=false"; 
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println(ex);
        }
    }
    public static void main(String[] args) {
    try {
        DBContext db = new DBContext();
        if (db.connection != null) {
            System.out.println("Yeb");
        } else {
            System.out.println("No");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
}
