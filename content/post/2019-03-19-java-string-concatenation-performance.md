---
title: "Java String Concatenation Performance"
date: 2019-03-18T21:35:56+07:00
tags: ["java", "jmh", "string", "concatenation"]
summary: "Bài trước mình giới thiệu sơ về JMH. Bài này mình sẽ so sánh hiệu năng các cách nối chuỗi trong Java "

draft: true
---

Hello anh em!  
Ở bài [trước]({{< ref "/post/2019-03-05-benchmark-with-jmh-and-gradle" >}}) mình đã giới thiệu các bạn cách tạo một project JMH với Gradle. Cuối bài mình có show một report như sau:

```
Benchmark                           Mode  Cnt         Score        Error  Units
StringAppend.bmStringBuffer        thrpt    5  13566863.267 ± 427443.554  ops/s
StringAppend.bmStringBufferx1000   thrpt    5     36998.492 ±   2895.325  ops/s
StringAppend.bmStringBufferx5      thrpt    5   5529261.499 ± 277625.096  ops/s
StringAppend.bmStringBuilder       thrpt    5  13462457.325 ± 978240.749  ops/s
StringAppend.bmStringBuilderx1000  thrpt    5     36989.126 ±   1716.705  ops/s
StringAppend.bmStringBuilderx5     thrpt    5   5466705.447 ± 176616.966  ops/s
StringAppend.bmStringConcat        thrpt    5  27930719.298 ± 581249.324  ops/s
StringAppend.bmStringConcatx1000   thrpt    5     47104.039 ±   2358.121  ops/s
StringAppend.bmStringConcatx5      thrpt    5   7170529.805 ± 383608.303  ops/s
StringAppend.bmStringJoin          thrpt    5  10204201.921 ± 463528.750  ops/s
StringAppend.bmStringJoinx1000     thrpt    5     30493.885 ±   1708.261  ops/s
StringAppend.bmStringJoinx5        thrpt    5   4322622.068 ±  49032.328  ops/s
StringAppend.bmStringPlus          thrpt    5  13689364.101 ± 509784.615  ops/s
StringAppend.bmStringPlusx1000     thrpt    5       288.086 ±     15.175  ops/s
StringAppend.bmStringPlusx5        thrpt    5   5590364.456 ± 277476.212  ops/s
```

đây là kết quả về **So sánh hiệu năng các cách nối chuỗi trong Java**. 

Và giờ mình sẽ làm giải thích vì sao lại có kết quả như vậy.  

#### 1. String Plus (Toán tử cộng)

Đây là cách nối chuỗi phổ biến nhất trong Java. Ví dụ:
```
String str = "Hello ";
str += "world";
```
dòng 1 sẽ tạo ra 1 đối tượng String có giá trị "Hello", dòng 2 sẽ tạo một object khác có giá trị "Hello world".  
Như kết quả mình show thì nó cách này có hiệu năng tốt ở x1 và x5 nhưng tệ nhất với x1000. Vì khi này Java sẽ chỉ tạo 1 vài object và sẽ 
không làm ảnh hưởng tới performance với số lần lặp lớn.

#### 2. String Concat

#### 3. String Builder

#### 4. String Buffer

#### 5. String Join

#### Kết luận

Nếu còn thiếu cách nào anh em có thể comment hoặc là tạo merge request để mình update thêm nhé ; ))