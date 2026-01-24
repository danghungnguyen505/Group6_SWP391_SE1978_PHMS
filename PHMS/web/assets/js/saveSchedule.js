/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// JS đơn giản chỉ để chọn giờ và copy giá trị sang form confirm
function selectTime(btn) {
    // Xóa class selected cũ
    document.querySelectorAll('.time-btn').forEach(b => b.classList.remove('selected'));
    // Thêm class selected mới
    btn.classList.add('selected');
    // Lưu giá trị
    document.getElementById('selectedTime').value = btn.innerText;
}

function submitBooking() {
    // Copy dữ liệu sang form POST
    document.getElementById('finalPetId').value = document.getElementsByName('petId')[0].value;
    document.getElementById('finalTime').value = document.getElementById('selectedTime').value;
    // Submit
    document.getElementById('confirmForm').submit();
}