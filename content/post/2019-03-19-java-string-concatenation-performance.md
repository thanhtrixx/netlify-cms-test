---
title: "Java String Concatenation Performance"
date: 2019-03-18T21:35:56+07:00
tags: ["java", "jmh", "string", "concatenation"]
summary: "Bài trước mình giới thiệu sơ về JMH. Bài này mình sẽ so sánh hiệu năng các cách nối chuỗi trong Java "
draft: false
---

Hello anh em!  
Ở bài [trước]({{< ref "/post/2019-03-05-benchmark-with-jmh-and-gradle" >}}) mình đã giới thiệu các bạn cách tạo một project JMH với Gradle. Bài này mình sẽ so sánh hiệu năng các cách nối chuỗi trong Java.

<!--more-->
Cuối bài mình có show một report như sau:

|             Benchmark             	|  Mode 	| Cnt 	|    Score    	|   	|    Error   	| Units 	|
|:---------------------------------:	|:-----:	|:---:	|:-----------:	|:-:	|:----------:	|:-----:	|
| StringAppend.bmStringBuffer       	| thrpt 	| 5   	| 13566863.27 	| ± 	| 427443.554 	| ops/s 	|
| StringAppend.bmStringBufferx0005  	| thrpt 	| 5   	| 5529261.499 	| ± 	| 277625.096 	| ops/s 	|
| StringAppend.bmStringBufferx1000  	| thrpt 	| 5   	| 36998.492   	| ± 	| 2895.325   	| ops/s 	|
| StringAppend.bmStringBuilder      	| thrpt 	| 5   	| 13462457.33 	| ± 	| 978240.749 	| ops/s 	|
| StringAppend.bmStringBuilderx0005 	| thrpt 	| 5   	| 5466705.447 	| ± 	| 176616.966 	| ops/s 	|
| StringAppend.bmStringBuilderx1000 	| thrpt 	| 5   	| 36989.126   	| ± 	| 1716.705   	| ops/s 	|
| StringAppend.bmStringConcat       	| thrpt 	| 5   	| 27930719.3  	| ± 	| 581249.324 	| ops/s 	|
| StringAppend.bmStringConcatx0005  	| thrpt 	| 5   	| 7170529.805 	| ± 	| 383608.303 	| ops/s 	|
| StringAppend.bmStringConcatx1000  	| thrpt 	| 5   	| 47104.039   	| ± 	| 2358.121   	| ops/s 	|
| StringAppend.bmStringJoin         	| thrpt 	| 5   	| 10204201.92 	| ± 	| 463528.75  	| ops/s 	|
| StringAppend.bmStringJoinx0005    	| thrpt 	| 5   	| 4322622.068 	| ± 	| 49032.328  	| ops/s 	|
| StringAppend.bmStringJoinx1000    	| thrpt 	| 5   	| 30493.885   	| ± 	| 1708.261   	| ops/s 	|
| StringAppend.bmStringPlus         	| thrpt 	| 5   	| 13689364.1  	| ± 	| 509784.615 	| ops/s 	|
| StringAppend.bmStringPlusx0005    	| thrpt 	| 5   	| 5590364.456 	| ± 	| 277476.212 	| ops/s 	|
| StringAppend.bmStringPlusx1000    	| thrpt 	| 5   	| 288.086     	| ± 	| 15.175     	| ops/s 	|

đây là kết quả về *so sánh hiệu năng các cách nối chuỗi trong Java*. 

Và giờ mình sẽ làm giải thích vì sao lại có kết quả như vậy.  

#### 1. String Plus (Toán tử cộng)

Đây là cách nối chuỗi phổ biến nhất trong Java. Ví dụ:
```java
String str = "Hello ";
str += "world";
```
dòng 1 sẽ tạo ra 1 đối tượng String có giá trị "Hello", dòng 2 sẽ tạo một String khác có giá trị "Hello world", nhưng trước khi tạo ra 1 String mới Java sẽ kiểm tra đối tượng đó đã ở trong String Poll hay không.
Trường hợp có sẽ không tạo ra String mới mà dùng String trong pool, nếu không có sẽ tạo ra String mới và thêm vào pool (mình sẽ có bài nói chi tiết hơn).  

Như kết quả mình show thì nó cách này có hiệu năng tốt ở x1 và x5 nhưng tệ nhất với x1000. Vì khi này Java sẽ chỉ tạo 1 vài String và sẽ 
không làm ảnh hưởng tới performance với số lần lặp lớn.

#### 2. String Concat

So sánh với String Plus thì tốc độ chênh lệch rất lớn. Vậy tại sao mà có chênh lệch lớn thế? Ta cùng xem code nhé:
```java
public String concat(String str) {
    int otherLen = str.length();
    if (otherLen == 0) {
        return this;
    }
    int len = value.length;
    char buf[] = Arrays.copyOf(value, len + otherLen);
    str.getChars(buf, len);
    return new String(buf, true);
}
```

Dòng code trên sẽ tạo ra 1 String mới bằng cách copy char array của 2 String trên. Như thế sẽ không có sự tham gia của String Pool và sẽ tiết kiệm được kha khá chi phí.
#### 3. String Builder

```java
public AbstractStringBuilder append(String str) {
    if (str == null)
        return appendNull();
    int len = str.length();
    ensureCapacityInternal(count + len);
    str.getChars(0, len, value, count);
    count += len;
    return this;
}

private void ensureCapacityInternal(int minimumCapacity) {
    // overflow-conscious code
    if (minimumCapacity - value.length > 0) {
        value = Arrays.copyOf(value,
                newCapacity(minimumCapacity));
    }
}
```

Ở trên là 2 phương thức sẽ được gọi khi ta thực hiện phương thức `append()`. 
Như ta thấy tinh thần cũng giống với concat ngoại trừ việc trả về `AbstractStringBuilder` thay vì tạo ra một String mới
#### 4. String Buffer
`String Buffer` là phiên bản `Thread safe` của `String Builder` nên việc kết quả chậm hơn là hiển nhiên. Ta có thể xem qua code sau để hiểu cách implement thread safe:
```java
public synchronized StringBuffer append(String str) {
    toStringCache = null;
    super.append(str);
    return this;
}
```
Từ khóa `synchronized` chỉ định trong một thời điểm chỉ có một thread có thể thực hiện được method, và nhờ có nó sẽ đảm bảo thread safe.

#### 5. String Join

#### Kết luận

Nếu còn thiếu cách nào anh em có thể comment hoặc là tạo merge request để mình update thêm nhé ; ))