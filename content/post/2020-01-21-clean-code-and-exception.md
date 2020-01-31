---
title: "Clean Code and Exception"
date: 2020-01-21T08:36:15+07:00
tags: ["java", "clean-code", "exception"]
draft: true
---

Không biết anh em lúc mới làm quen thế nào chứ lúc mình học Java thì cái làm mình cảm thấy khó chịu nhất là Exception. Cứ hở một chút là bắt `try/catch` (sẽ có một bài viết chi tiết hơn về vấn đề này) và làm cho code mình trở nên cực kỳ kinh khủng. Nhưng sau thời gian tìm hiểu thì mình nhận thấy đây là một thứ khá hay ho trong lập trình.

Vì sao à? Đọc tiếp nhé :v
<!--more-->
Giả sử síp kêu mình viết một hàm tính lương. Thông số truyền vào số ngày làm việc trong tháng và tiền lương trong một ngày. Quá đơn giản phải k ;)
```java
pubic int calcSalary(int workingDay, int salaryPerDay) {
    return workingDay * salaryPerDay;
}
```
Sau khi đưa síp review thì bị la! `workingDay` và `salaryPerDay` âm thì như thế nào?
![WTF](https://media.giphy.com/media/tJeGZumxDB01q/giphy.gif)
Mình nhanh nhẩu trả lời: Thì cái thằng gọi bên ngoài phải handle chứ!  
Ổng phản damage: Tao là thằng gọi nè, chú phải tự validate chứ! Đừng quá tin anh. Vừa nói ổng vừa mỉm một nụ cười bí ẩn :~

Thế là hậm hụi ngồi viết lại :(. Vấn đề bắt đầu từ đây. Signature của hàm dễ hiểu nhìn vào là hiểu ngay. Giờ phải thêm thông tin để hàm gọi biết param truyền vào đúng valid không nên mình trả về là một class chứa lương và mã lỗi, mã lỗi là 0 tương ứng không có lỗi
```java
class SalaryResult {
    private int salary = 0;
    private int errorCode = 0;

    // getters and settters
}

pubic SalaryResult calcSalary(int workingDay, int salaryPerDay) {
    SalaryResult res = new SalaryResult();
    
    if(workingDay < 0) {
        res.setErrorCode(1)
    }

    if(salaryPerDay < 0) {
        res.setErrorCode(2)
    }

    res.setSalary(workingDay * salaryPerDay)
    
    return res;
}
```
Síp review thì lại bắt sửa tiếp. Lý do vì ổng phải điều phối việc tính lương và chuyển lương. Handle mã lỗi thôi thì ổng phải map mấy cái mã lỗi trả về để show cho user. Việc này thì ổng nói không phải là việc của ổng. WTF x2 ;))