---
title: Custom Exception and speedup it
date: 2020-04-25T16:24:15+07:00
tags:
  - java
  - exception
  - speedup
  - performance
  - jmh
draft: false
description: Hehe
---
Ở bài trước mình có đề cập đến `Exception`. Bài này mình sẽ nói về `Custom Exception` và chỉ các bạn cách giải quyết vấn đề `performance` khi sử dụng `Exception` nhé!

<!--more-->

Giả sử síp kêu mình viết một hàm tính lương. Thông số truyền vào số ngày làm việc trong tháng và tiền lương trong một ngày. Quá đơn giản phải k ;)

```java
pubic int calcSalary(int workingDay, int salaryPerDay) {
    return workingDay * salaryPerDay;
}
```

Sau khi đưa síp review thì bị la! `workingDay` và `salaryPerDay` âm thì như thế nào?
![WTF](https://media.giphy.com/media/tJeGZumxDB01q/giphy.gif)
Mình nhanh nhẩu trả lời: Thì cái thằng gọi bên ngoài phải handle chứ!\
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

Síp review thì lại bắt sửa tiếp. Lý do vì ổng phải điều phối việc tính lương và chuyển lương. Handle mã lỗi thôi thì ổng phải map mấy cái mã lỗi trả về để show cho user. Việc này thì ổng nói không phải là việc của ổng, "It not my business". WTF x2 ;))
Như vậy mình cần làm cách nào đó để thỏa 2 yêu cầu sau:

* \#1: Signature của hàm phải tưởng minh. Nhìn cái hiểu liền
* \#2: Trả về cho thằng gọi chi tiết về lỗi nhất có thể

Sau thời gian tìm hiểu thì cái vấn đề của mình gặp thì cũng đã có rất nhiều người gặp và nó đã được giải quyết với một cách đơn giản là `Exception` hoặc `custom Exception` như sau:

```java
public int calcSalary(int workingDay, int salaryPerDay) throws Exception {

    if(workingDay < 0)
        throw new Exception("WorkingDay less than zero");

    if(salaryPerDay < 0)
       throw new Exception("SalaryPerDay less than zero");

 return workingDay * salaryPerDay;
 }
```

Như vậy chỉ cần thêm khai báo `throws Exception` và khi throw exception mình truyền thêm message thì mọi chuyện trở nên rất đơn giản.

Demo chương trình bây giờ như sau:

```java
public class Salary {
    public static void main(String[] args) {

        try {
            int salary = calcSalary(21, 1_000_000);
            System.out.println("Salary: " + salary);

            // bla bla ble...
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public static int calcSalary(int workingDay, int salaryPerDay) throws Exception {

        if (workingDay < 0)
            throw new Exception("WorkingDay less than zero");

        if (salaryPerDay < 0)
            throw new Exception("SalaryPerDay less than zero");

        return workingDay * salaryPerDay;
    }
}
```

Các bạn có thể thay thế thay thế `workingDay` hoặc `salaryPerDay` nhỏ hơn 0 để xem kết quả nhé
![WTF](https://media.giphy.com/media/7j3UoXzbjvaIo/giphy.gif)

**Kết luận:** bằng việc sử dụng `Exception` hoặc `custom Exception` ta có thể:

* Làm cho method signature dễ hiểu
* Trả về thêm thông tin lỗi (nếu có) bằng cách sử dụng `custom Exception`, mình sẽ có bài nói rõ hơn về cái này nhé.
* Code control bên ngoài dễ hiểu hơn khi tách biệt code bussiness và handle lỗi, mình cũng sẽ có bài về phần này

  và rồi còn có những cái không tốt như cái này không?