<%-- 
    Document   : edit
    Created on : Jan 22, 2026, 4:10:38 AM
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
        <h2>Edit Medicine</h2>

        <form action="medicine" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="medicineId" value="${medicine.medicineId}">

            Name:
            <input type="text" name="name" value="${medicine.name}" required><br><br>

            Unit:
            <input type="text" name="unit" value="${medicine.unit}" required><br><br>

            Price:
            <input type="number" step="0.01" name="price" value="${medicine.price}" required><br><br>

            Quantity:
            <input type="number" name="stockQuantity" value="${medicine.stockQuantity}" required><br><br>

            <input type="submit" value="Update">
            <a href="medicine">Cancel</a>
        </form>
    </body>
</html>
