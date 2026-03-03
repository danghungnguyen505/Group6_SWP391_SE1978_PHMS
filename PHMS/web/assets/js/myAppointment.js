/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/**
 * myAppointment.js
 * Xử lý Modal xem ghi chú cho Pet Owner
 */
function openModal(button) {
    // 1. Lấy nội dung note
    var noteContent = button.getAttribute("data-note");
    // 2. Điền vào modal
    var modalBody = document.getElementById("modalNoteContent");
    if (modalBody) {
        modalBody.innerText = noteContent;
    }
    // 3. Hiển thị modal
    var modal = document.getElementById("noteModal");
    if (modal) {
        modal.style.display = "block";
    }
}
function closeModal() {
    var modal = document.getElementById("noteModal");
    if (modal) {
        modal.style.display = "none";
    }
}
// Đóng khi click ra ngoài
window.onclick = function(event) {
    var modal = document.getElementById("noteModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}