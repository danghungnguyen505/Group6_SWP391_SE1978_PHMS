<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- LEFT SIDEBAR -->
<nav class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-plus-square"></i> VetCare Pro
    </div>

    <ul class="menu">
        <li>
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="${requestScope.activePage == 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-table-columns"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="text-danger ${requestScope.activePage == 'emergencyTriage' ? 'active' : ''}">
                <i class="fa-solid fa-truck-medical"></i> Emergency Triage
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/receptionist/appointment" class="${requestScope.activePage == 'appointments' ? 'active' : ''}">
                <i class="fa-regular fa-calendar-check"></i> Appointments
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="${requestScope.activePage == 'billing' ? 'active' : ''}">
                <i class="fa-regular fa-credit-card"></i> Billing
            </a>
        </li>
<!--        <li>
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="${requestScope.activePage == 'administration' ? 'active' : ''}">
                <i class="fa-solid fa-gear"></i> Administration
            </a>
        </li>-->
    </ul>

    <div class="help-box">
        <div class="help-text">Need help?</div>
        <a href="#" class="btn-contact">Contact Support</a>
    </div>
</nav>
