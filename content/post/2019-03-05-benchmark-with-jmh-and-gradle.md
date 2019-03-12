---
title: "Benchmark với Jmh và Gradle"
date: 2019-03-05T18:29:49+07:00
tags: ["java", "jmh", "gradle"]
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

B5: và benchmark nào  
`./gradlew --no-daemon clean jmh`  
kết quả được show ở console hoặc có thể xem lại bằng lệnh sau:  
`cat build/reports/jmh/results.txt`
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
Anh em có thể tham khảo [git repo](https://gitlab.com/thanhtrixx/jmh-gradle-example) sau nhé. :))