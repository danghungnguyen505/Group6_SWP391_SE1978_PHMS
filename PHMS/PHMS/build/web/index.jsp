<%-- 
    Document   : index
    Created on : Jan 21, 2026, 3:58:06 PM
    Author     : Nguyen Dang Hung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>PHMS - Pet Hospital</title>
    </head>
    <body>
        <h1>Welcome to Pet Hospital Management System</h1>
        <a href="login.jsp">Login Here</a>
        <table border="1">
            <tr>
                <th>Name</th>
                <th>Unit</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <c:forEach var="m" items="${medicines}">
                <tr>
                    <td>${m.name}</td>
                    <td>${m.unit}</td>
                    <td>${m.price}</td>
                    <td>${m.stockQuantity}</td>
                    <td>${m.status}</td>
                    <td>
                        <a href="medicine?action=edit&id=${m.medicineId}">Edit</a>
                        |
                        <a href="medicine?action=delete&id=${m.medicineId}"
                           onclick="return confirm('Are you sure you want to delete this medicine?')">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </table>

        <br>
        <a href="medicine?action=add">Add new medicine</a>
    </body>
</html>
