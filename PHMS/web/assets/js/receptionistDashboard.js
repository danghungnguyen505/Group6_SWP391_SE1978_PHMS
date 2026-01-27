/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Hàm mở Modal
function openModal(button) {
    // 1. Lấy nội dung note từ thuộc tính data-note của nút bấm
    var noteContent = button.getAttribute("data-note");
    // 2. Điền vào modal body
    var modalContent = document.getElementById("modalNoteContent");
    if (modalContent) {
        modalContent.innerText = noteContent;
    }
    // 3. Hiển thị modal
    var modal = document.getElementById("noteModal");
    if (modal) {
        modal.style.display = "block";
    }
}
// Hàm đóng Modal khi bấm nút X
function closeModal() {
    var modal = document.getElementById("noteModal");
    if (modal) {
        modal.style.display = "none";
    }
}
// Đóng modal khi click ra vùng đen bên ngoài
window.onclick = function(event) {
    var modal = document.getElementById("noteModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
