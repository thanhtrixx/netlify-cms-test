---
title: "Benchmark với Jmh và Gradle"
date: 2019-03-05T18:29:49+07:00
draft: false
---

JMH là Java Microbenchmark Harness. JMH là công cụ giúp cho cho việc benchmark được chính xác và dễ đàng hơn.  
Việc benchmark này cực kỳ có ích đối với ứng dụng cần tốc độ cao, giúp chọn ra thuật toán hay thư viện cho tốc độ tốt nhất.

OK! Lý thuyết vậy đủ rồi, đi vào thực hành nào. Việc chúng ta cần làm là viết 1 project so sánh tốc độ của các cách nối chuỗi trong Java. Nhớ cài java và gradle trước nhé anh em

B1: Tạo ra 1 gradle project. Các bạn mở Terminal ra và gõ lệnh sau:  
`gradle init`  
rồi chọn những option sau:
```
Select type of project to generate:
  1: basic
  2: groovy-application
  3: groovy-library
  4: java-application
  5: java-library
  6: kotlin-application
  7: kotlin-library
  8: scala-library
Enter selection (default: basic) [1..8] 4

Select build script DSL:
  1: groovy
  2: kotlin
Enter selection (default: groovy) [1..2] 1

Select test framework:
  1: junit
  2: testng
  3: spock
Enter selection (default: junit) [1..3] 1

Project name (default: jmh-gradle-example):
Source package (default: jmh.gradle.example): tri.le.jmh
```

B2: Copy Copy thư mục main ra thư mục jmh  
`cp -r src/main src/jmh`  
Mục đích của việc này là để phân biệt 3 phần: code chính, code test và code benchmark

B3: Update file `build.gradle`, thêm `id "me.champeau.gradle.jmh" version "0.4.8"` vào `plugins`

B4: Setup xong rồi, giờ viết code thôi ; )). Để nhanh thì anh em copy [file](https://gitlab.com/thanhtrixx/jmh-gradle-example/blob/master/src/jmh/java/tri/le/jmh/StringAppend.java) này về và mình sẽ giải thích luôn:

```java
@Warmup(iterations = 5, time = 1, timeUnit = TimeUnit.SECONDS)
```
thực hiện "làm nóng" 5 lần mỗi lần 1 giây. Vậy tại sao cần warmup? Java sẽ tự động tối ưu hóa code, vì thế khi warmup sẽ giúp ta có được kết quả benchmark chính xác

```java
@Measurement(iterations = 5, time = 1, timeUnit = TimeUnit.SECONDS)
```
thực hiện benchmark trong 5 lần mỗi lần 1 giây

```java
@Fork(1)
@State(Scope.Thread)
```
JMH sẽ tạo ra 1 tiến trình con cho mỗi case benchmark. Việc tạo ra tiến trình con này để đảm bảo bộ tối ưu hóa được reset lại và kết quả benchmark được chính xác hơn

B5: và mình benchmark nào  
`./gradlew --no-daemon clean jmh`


Anh em có thể tham khảo [git repo](https://gitlab.com/thanhtrixx/jmh-gradle-example) sau nhé. :))