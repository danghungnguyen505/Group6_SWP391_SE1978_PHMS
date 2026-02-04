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
        <h1>Pet Hospital Management System (PHMS)</h1>
        <table border='1'>
            <tr>
                <th>Public / Auth</th>
                <th>Pet Owner</th>
                <th>Receptionist</th>
                <th>Veterinarian</th>
                <th>Nurse</th>
                <th>Admin</th>
            </tr>

            <tr>
                <td><a href="home">Home</a></td>
                <td><a href="myPetOwner">My Pets</a></td>
                <td><a href="receptionist/dashboard">Dashboard</a></td>
                <td><a href="veterinarian/dashboard">Dashboard</a></td>
                <td><a href="nurse/dashboard">Dashboard</a></td>
                <td><a href="admin/dashboard">Dashboard</a></td>
            </tr>

            <tr>
                <td><a href="login">Login</a></td>
                <td><a href="pet/add">Add Pet</a></td>
                <td><a href="receptionist/appointment">Appointments</a></td>
                <td><a href="veterinarian/scheduling">My Schedule</a></td>
                <td><a href="nurse/lab/queue">Lab Queue</a></td>
                <td><a href="admin/staff/list">Staff List</a></td>
            </tr>

            <tr>
                <td><a href="register">Register</a></td>
                <td><a href="booking">Book Appointment</a></td>
                <td><a href="receptionist/emergency/queue">Emergency Queue</a></td>
                <td><a href="veterinarian/emr/queue">EMR Queue</a></td>
                <td><a href="nurse/lab/update?id=1">Update Lab</a></td>
                <td><a href="admin/staff/create">Create Staff</a></td>
            </tr>

            <tr>
                <td><a href="forgot-password">Forgot Password</a></td>
                <td><a href="myAppointment">My Appointments</a></td>
                <td><a href="receptionist/invoice/create?apptId=1">Create Invoice</a></td>
                <td><a href="veterinarian/emr/create?apptId=1">Create EMR</a></td>
                <td><a href="leave/request">HRM: Request Leave</a></td>
                <td><a href="admin/staff/update?id=1">Update Staff</a></td>
            </tr>

            <tr>
                <td><a href="change-password">Change Password</a></td>
                <td><a href="my-medical-records">Medical Records</a></td>
                <td><a href="receptionist/invoice/detail?invoiceId=1">Invoice Detail</a></td>
                <td><a href="veterinarian/emr/records">EMR Records</a></td>
                <td><a href="leave/my-requests">HRM: My Leave List</a></td>
                <td><a href="admin/dashboard">Service List</a></td>
                <!--<td><a href="admin/service/list">Service List</a></td> -->
            </tr>

            <tr>
                <td><a href="profile">Profile</a></td>
                <td><a href="sos">SOS</a></td>
                <td><a href="leave/request">HRM: Request Leave</a></td>
                <td><a href="leave/request">HRM: Request Leave</a></td>
                <td></td>
                <td><a href="admin/add-service">Add Service</a></td>
            </tr>

            <tr>
                <td><a href="logout">Logout</a></td>
                <td><a href="ai/chat">AI Chat</a></td>
                <td><a href="leave/my-requests">HRM: My Leave List</a></td>
                <td><a href="leave/my-requests">HRM: My Leave List</a></td>
                <td></td>
                <td><a href="admin/edit-service?id=1">Edit Service</a></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td><a href="admin/medicine/list">Medicine List</a></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td><a href="admin/medicine/add">Add Medicine</a></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td><a href="admin/medicine/update?id=1">Update Medicine</a></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td><a href="admin/leave/pending">HRM: Leave Pending</a></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td><a href="admin/feedback/list">Feedback List</a></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td><a href="admin/reports">Business Report</a></td>
            </tr>

        </table>

    </body>
</html>