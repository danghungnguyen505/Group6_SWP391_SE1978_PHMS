<%-- 
    Document   : list
    Created on : Jan 22, 2026, 4:07:48 AM
    Author     : thanh
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Medicine List</h2>

<a href="medicine?action=add">Add Medicine</a>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Unit</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Action</th>
    </tr>

    <c:forEach items="${medicines}" var="m">
        <tr>
            <td>${m.medicineId}</td>
            <td>${m.name}</td>
            <td>${m.unit}</td>
            <td>${m.price}</td>
            <td>${m.stockQuantity}</td>
            <td>
                <a href="medicine?action=edit&id=${m.medicineId}">Edit</a> |
                <a href="medicine?action=delete&id=${m.medicineId}"
                   onclick="return confirm('Delete?')">Delete</a>
            </td>
        </tr>
    </c:forEach>
</table>
