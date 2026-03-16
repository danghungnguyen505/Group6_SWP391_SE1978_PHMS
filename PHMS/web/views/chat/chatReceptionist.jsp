<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>VetCare Pro - Customer Chat</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">

<style>

.chat-layout{
display:flex;
height:500px;
background:white;
border-radius:10px;
box-shadow:0 0 10px rgba(0,0,0,0.1);
}

.customer-list{
width:220px;
border-right:1px solid #ddd;
overflow-y:auto;
}

.customer{
padding:12px;
cursor:pointer;
border-bottom:1px solid #eee;
}

.customer:hover{
background:#f1f5f9;
}

.chat-area{
flex:1;
display:flex;
flex-direction:column;
padding:10px;
}

.messages{
flex:1;
overflow-y:auto;
background:#f5f5f5;
padding:15px;
border-radius:10px;
}

.message{
padding:10px 15px;
margin:8px 0;
border-radius:15px;
max-width:60%;
}

.sent{
background:#2563eb;
color:white;
margin-left:auto;
}

.received{
background:#e2e8f0;
}

</style>

</head>

<body>

<!-- SIDEBAR -->
<nav class="sidebar">

<div class="brand">
<i class="fa-solid fa-plus-square"></i> VetCare Pro
</div>

<ul class="menu">

<li>
<a href="${pageContext.request.contextPath}/receptionist/dashboard">
<i class="fa-solid fa-table-columns"></i> Dashboard
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/receptionist/scheduling">
<i class="fa-solid fa-calendar"></i> Staff Scheduling
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/receptionist/appointment">
<i class="fa-regular fa-calendar-check"></i> Appointments
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/ReceptionistChatController" class="active">
<i class="fa-solid fa-comments"></i> Customer Chat
</a>
</li>

</ul>

</nav>

<!-- MAIN CONTENT -->
<main class="main-content">

<h2>Customer Support Chat</h2>

<div class="chat-layout">

<div class="customer-list">

<c:forEach var="u" items="${users}">

<div class="customer" onclick="openChat(${u})">
User ${u}
</div>

</c:forEach>

</div>

<div class="chat-area">

<div id="chatBox" class="messages"></div>

<div class="d-flex mt-2">

<input id="msg" class="form-control me-2" placeholder="Type message...">

<button onclick="sendMsg()" class="btn btn-primary">
<i class="fa-solid fa-paper-plane"></i>
</button>

</div>

</div>

</div>

</main>

<script>

let receiverId = 0;

function openChat(id){
receiverId=id;
loadChat();
}

function sendMsg(){

let msg=document.getElementById("msg").value;

fetch("/PHMS/SendMessageController",{
method:"POST",
headers:{"Content-Type":"application/x-www-form-urlencoded"},
body:"receiver="+receiverId+"&message="+msg
});

document.getElementById("msg").value="";
}

function loadChat(){

if(receiverId==0) return;

fetch("/PHMS/LoadChatController?user="+receiverId)
.then(res=>res.text())
.then(data=>{
document.getElementById("chatBox").innerHTML=data;

let box=document.getElementById("chatBox");
box.scrollTop=box.scrollHeight;
});

}

setInterval(loadChat,3000);

</script>

</body>
</html>