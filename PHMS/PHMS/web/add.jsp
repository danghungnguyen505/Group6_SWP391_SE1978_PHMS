<%-- 
    Document   : add
    Created on : Jan 22, 2026, 4:12:28 AM
    Author     : thanh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Add Medicine</h2>

        <form action="medicine" method="post">
            <input type="hidden" name="action" value="insert">

            Name:
            <input type="text" name="name" required><br><br>

            Unit:
            <input type="text" name="unit" required><br><br>

            Price:
            <input type="number" step="0.01" name="price" required><br><br>

            Quantity:
            <input type="number" name="stockQuantity" required><br><br>

            <input type="submit" value="Add">
            <a href="medicine">Cancel</a>
        </form>

    </body>
</html>
