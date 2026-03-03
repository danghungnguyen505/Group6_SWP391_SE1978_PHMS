<%-- 
    Document   : pet-list
    Created on : 22 thg 1, 2026, 02:29:56
    Author     : quag
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Pets List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #f3f4f6;
            }
            .pet-card {
                background: white;
                border: none;
                border-radius: 12px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                transition: transform 0.2s;
                cursor: pointer;
                overflow: hidden;
            }
            .pet-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 15px rgba(0,0,0,0.1);
            }
            .pet-img-wrapper {
                height: 180px;
                background-color: #e5e7eb;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .pet-img-wrapper img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-list text-muted me-2"></i>My Pets List</h2>
                <a href="pet-form" class="btn btn-success rounded-pill px-4">
                    <i class="fas fa-plus me-2"></i>Add New Pet
                </a>
            </div>

            <form action="pets" method="GET" class="mb-4">
                <div class="input-group shadow-sm">
                    <%
                        String search = (String) request.getAttribute("searchKeyword");
                        if (search == null)
                            search = "";
                    %>
                    <input type="text" name="search" class="form-control" placeholder="Enter pet name to search..." value="<%= search%>">
                    <button class="btn btn-primary" type="submit">
                        <i class="fas fa-search me-2"></i>Search
                    </button>
                    <% if (!search.isEmpty()) { %>
                    <!-- Nút xóa tìm kiếm nếu đang tìm -->
                    <a href="pets" class="btn btn-secondary">Clear</a>
                    <% }%>
                </div>
            </form>

            <div class="row g-4">
                <c:forEach items="${petList}" var="p">
                    <div class="col-md-4 col-sm-6">
                        <div class="pet-card h-100">
                            <div class="pet-img-wrapper">
                                <img src="https://placedog.net/300/200?id=${p.petId}" alt="${p.name}">
                            </div>
                            <div class="card-body p-3">
                                <h5 class="card-title fw-bold">${p.name}</h5>
                                <small class="text-muted">${p.species}</small>
                                <p class="mt-2 text-truncate" style="font-size: 0.9rem;">${p.historySummary}</p>

                                <a href="pet-detail?id=${p.petId}" class="btn btn-outline-success w-100 mt-2 btn-sm">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty petList}">
                    <div class="alert alert-warning">No pets found for this owner.</div>
                </c:if>
            </div>
        </div>
    </body>
</html>
