/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

function selectTime(element, timeValue) {
        // 1. Xóa class 'selected' ở tất cả các nút khác
        var buttons = document.getElementsByClassName('time-btn');
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].classList.remove('selected');
        }

        // 2. Thêm class 'selected' cho nút vừa bấm
        element.classList.add('selected');

        // 3. Gán giá trị giờ vào ô input ẩn để gửi về Server
        document.getElementById('selectedTimeSlot').value = timeValue;
        
        // (Debug) Kiểm tra xem đã nhận giá trị chưa
        console.log("Selected time: " + timeValue);
    }