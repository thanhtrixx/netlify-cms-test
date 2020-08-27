---
title: "Try/Catch Explain"
date: 2020-04-22T00:01:01+07:00
tags: ["java", "trycatch", "exception",  "explain"]
draft: false
---

Tiếp tục loạt bài về `Exception` [Clean Code with Exception](/post/2020-01-21-clean-code-with-exception). Bài này mình sẽ nói nói rõ hơn về `try/catch` và minh oan cho `try/catch` khi bị chê là làm cho performance của chương trình chậm lại.
<!--more-->
Đầu tiên mình xin giải thích `try` là gì và `catch` là gì:
+ `try` là một từ khoá của Java để khai báo một đoạn code mà trong đó khi `throws` ra một `Throwable` sẽ được xử lý bởi đoạn `catch` khai báo sau đó.
+ `catch` là một từ khoá của Java để khai báo một đoạn code sẽ được thực thi nếu bắt được một `Throwable` được `throws` ra bởi các đoạn code nằm trong `try` khai báo trước đó.  

`try` và `catch` là một cặp luôn luôn đi cùng nhau. 

### 1. Các tình huống sử dụng
+ Bắt tất cả các `Exception`
```java
try {
  // bla bla bla
}
catch (Exception e) {
  // fu fu fu
}
```


+ Bắt các `IOException` trước và `Exception` sau
```java
try {
  // bla bla bla
}
catch (IOException e) {
  // fu fu fu
}
catch (Exception e) {
  // fe fe fe
}
```


Lưu ý là các `Exception` con nên nằm trước, các `Exception` cha nên nằm sau. 

+ Bắt các `IOException` và `RuntimeException` và xử lý trong cùng một statement
```java
try {
  // bla bla bla
}
catch (IOException | RuntimeException e) {
  // fu fu fu
}
catch (Exception e) {
  // fe fe fe
}
```

### 2. Checked và UnChecked  Exceptions 
Khi dùng Java một trong những điểm làm mình không thích được ở nó là `Checked Exception` khi mà nó bắt buộc mình phải handle `Exception`. Nếu ta cố ý không `try/catch` cho đoạn code `throws` ra `Checked Exception` thì compiler sẽ báo lỗi và không thể build được dù có thể `Checked Exception` sẽ không bao giờ xảy ra. Điều này dẫn đến code dư thừa không cần thiết.

![WTF](https://media.giphy.com/media/QABIA4v1Y1v8Y/source.gif)

Mình lấy ví dụ như trường hợp 
```java
Cipher.getInstance("AES/CBC/PKCS5Padding");
```
 hoặc
 ```java
 dataToEncrypt.getBytes("UTF-8");
 ```
  sẽ luôn luôn cần phải hand exception do signature của nó khai báo sẽ `throws` ra các `Checked Exception` cho dù mình đảm bảo code trên không bao giờ bị `Exception`. Và khi đó code mình sẽ đại loại thế này
```java
byte [] bytes;
try {
   bytes = dataToEncrypt.getBytes("UTF-8");
} catch (UnsupportedEncodingException e) {
    // f*ck
}
// bla bla bla
...
```
hoặc
```java
try {
  byte [] bytes = dataToEncrypt.getBytes("UTF-8");
  // bla bla bla
  ...
} catch (UnsupportedEncodingException e) {
    // f*ck
}
```
Đáng lẽ ra nó chỉ đơn giản như vầy thôi
```java
byte [] bytes = dataToEncrypt.getBytes("UTF-8");
// bla bla bla
...
```
![WTF](https://media.giphy.com/media/13Q9MdRZh4UZVu/source.gif)

Nói lang mang quá rồi. Vậy làm thế nào để xác định một `Checked Exception`? Các bạn nhìn hình sau nhé: 

![Exception hierarchy](/img/exception-hierarchy.png)

Mấy class màu xanh và con của tụi nó là `UnChecked  Exception` còn mấy cái màu đỏ hay là những class con của `Exception` nhưng không phải `RuntimeException` là `Checked  Exception` (giải thích rối não vlc :D)

Có một điểm khá thú vị là `.NET` và các `JVM language` như `Kotlin`, `Groovy`, `Scala` đều không có khái niệm `Checked Exception` hay nói cách khác người dùng cần tự biết mà handle `Exception` thay vì bị bắt buộc handle. Vậy là anh cả `Java` đã bị đàn em cho ra rìa rồi ;))

![NONO](https://media.giphy.com/media/d1E1msx7Yw5Ne1Fe/giphy.gif)

### 3. Try performance impact
Mình thường được các "đại ka" có kinh nghiệm chỉ giáo là không nên dùng `Exception` với lý do là sẽ làm hệ thống chạy chậm lại. Mà thay vào đó có 2 cách để giải quyết:
+ Nên trả về thêm thông tin mã lỗi và mình sẽ gặp tình huống giống như bài này [Clean Code with Exception](/post/2020-01-21-clean-code-with-exception).
+ Gộp tất cả các thông tin xử lý vào một class info. Class info trên sẽ được truyền qua các method xử lý. Khi có lỗi gì thì method đang xử lý sẽ set thông tin vào class info này và cái phương thức gọi cần phải check lại xem có lỗi hay không. Code smell quá ;((

Haizz! Đọc tới đây chắc có bạn sẽ nói **đây là cái giá của việc muốn code chạy nhanh**. Nhưng thật sự không phải thế. Bản chất `try` không làm chậm code mà nó chỉ khai báo rằng những đoạn code nằm trong nó nếu có lỗi sẽ được phần code trong `catch` dưới nó xử lý. Bạn có thể xem kỹ hơn ở [đây](https://stackoverflow.com/questions/16451777/is-it-expensive-to-use-try-catch-blocks-even-if-an-exception-is-never-thrown) nhé.

Nói thế thì do đâu mà khi 1 `Exception` xảy ra làm chương trình chạy chậm lại?

![???](https://media.giphy.com/media/7K3p2z8Hh9QOI/giphy.gif)

Câu trả lời là do **quá trình collect `stacktrace`** làm chậm chương trình. Và mình hứa sẽ có một bài hướng dẫn các bạn giải quyết vấn đề này!