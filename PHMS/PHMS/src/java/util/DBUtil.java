/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // 👉 SỬA ĐÚNG TÊN DB CỦA BẠN
    private static final String URL =
        "jdbc:sqlserver://LAPTOP_OF_THANH:1433;"
      + "databaseName=PHMS_DB;"
      + "encrypt=true;"
      + "trustServerCertificate=true";

    private static final String USER = "sa";        // hoặc user của bạn
    private static final String PASSWORD = "123"; // sửa đúng password

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("✅ SQL Server Driver loaded");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ SQL Server Driver NOT FOUND");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
