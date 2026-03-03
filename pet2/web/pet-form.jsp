<%-- 
    Document   : pet-form
    Created on : 22 thg 1, 2026, 03:07:59
    Author     : quag
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Pet"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Pet Form</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <%
            // Lấy dữ liệu Pet nếu đang ở chế độ Sửa
            Pet p = (Pet) request.getAttribute("pet");
            String id = (p != null) ? String.valueOf(p.getPetId()) : "";
            String name = (p != null) ? p.getName() : "";
            String species = (p != null) ? p.getSpecies() : "";
            String summary = (p != null) ? p.getHistorySummary() : "";
            String title = (p != null) ? "Edit Pet Information" : "Add New Pet";
        %>

        <div class="container mt-5" style="max-width: 600px;">
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0"><%= title%></h4>
                </div>
                <div class="card-body">
                    <form action="pet-form" method="POST">
                        <!-- Input ID ẩn (để biết là đang sửa hay thêm) -->
                        <input type="hidden" name="id" value="<%= id%>">

                        <div class="mb-3">
                            <label class="form-label">Pet Name</label>
                            <input type="text" class="form-control" name="name" value="<%= name%>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Species (Loài)</label>
                            <input type="text" 
                                   class="form-control" 
                                   name="species" 
                                   value="<%= species%>" 
                                   placeholder="Ví dụ: Dog, Cat, Hamster..." 
                                   required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">History / Description</label>
                            <textarea class="form-control" name="summary" rows="3"><%= summary%></textarea>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <a href="pets" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
