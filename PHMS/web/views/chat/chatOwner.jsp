<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
model.User user = (model.User) session.getAttribute("account");

if(user == null || !user.getRole().equals("PetOwner")){
    response.sendRedirect("../login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>VetCare Pro - Chat</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">

<style>

.chat-wrapper{
display:flex;
justify-content:center;
margin-top:20px;
}

.chat-box{
width:700px;
background:white;
border-radius:10px;
box-shadow:0 0 10px rgba(0,0,0,0.1);
padding:20px;
}

.messages{
height:400px;
overflow-y:auto;
background:#f5f5f5;
padding:15px;
border-radius:10px;
margin-bottom:10px;
}

.message{
padding:10px 15px;
margin:8px 0;
border-radius:15px;
max-width:60%;
}

.sent{
background:#0d6efd;
color:white;
margin-left:auto;
}

.received{
background:#e4e6eb;
}

</style>

</head>

<body>

<!-- SIDEBAR -->
<nav class="sidebar">
<div class="brand">
<i class="fa-solid fa-plus"></i> VetCare Pro
</div>

<div class="menu-label">Main Menu</div>

<ul class="menu">

<li>
<a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
<i class="fa-solid fa-border-all"></i> Dashboard
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/booking" class="nav-link">
<i class="fa-regular fa-calendar-check"></i> Appointments
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/myAppointment" class="nav-link">
<i class="fa-solid fa-calendar-check"></i> My Appointments
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/myPetOwner" class="nav-link">
<i class="fa-solid fa-paw"></i> My Pets
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/my-medical-records" class="nav-link">
<i class="fa-solid fa-file-medical"></i> Medical Records
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/billing" class="nav-link">
<i class="fa-regular fa-credit-card"></i> Billing
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/aiHealthGuide" class="nav-link">
<i class="fa-solid fa-bolt"></i> AI Health Guide
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/ChatRedirectController" class="nav-link active">
<i class="fa-solid fa-comments"></i> Chat
</a>
</li>

</ul>

<div class="support-box">
<p>Need help?</p>
<button class="btn-support">Contact Support</button>
</div>

</nav>

<!-- MAIN CONTENT -->
<main class="main-content">

<h2>Customer Support Chat</h2>

<div class="chat-wrapper">

<div class="chat-box">

<div id="chatBox" class="messages"></div>

<div class="d-flex">

<input id="msg" class="form-control me-2" placeholder="Type message...">

<button onclick="sendMsg()" class="btn btn-primary">
<i class="fa-solid fa-paper-plane"></i>
</button>

</div>

</div>

</div>

</main>

<script>

let receiverId = 7;

function sendMsg(){

let msg = document.getElementById("msg").value;

fetch("/PHMS/SendMessageController",{
method:"POST",
headers:{"Content-Type":"application/x-www-form-urlencoded"},
body:"receiver="+receiverId+"&message="+msg
});

document.getElementById("msg").value="";
}

function loadChat(){

fetch("/PHMS/LoadChatController?user="+receiverId)
.then(res=>res.text())
.then(data=>{
document.getElementById("chatBox").innerHTML=data;

let box=document.getElementById("chatBox");
box.scrollTop=box.scrollHeight;
});

}

setInterval(loadChat,3000);

loadChat();

</script>

</body>
</html>