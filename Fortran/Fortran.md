### 基础知识

~~~fortran
IMPLICIT NONE
! 建议所有代码都加入此内容
! 加入这个叙述之后，会把内定型态的功能关闭
~~~

简单示例：

~~~fortran
! Free Format
program main
IMPLICIT NONE
write(*,*) “hello” ! 打印出 hello 这个字
write(*,*) &
“hello”
wri&
te(*,*) “hello”
end
~~~

! 为注释标识符号

& 为换行标识符号

write(位置，格式) "字符串"

### 变量定义

~~~fortran
! 变量定义

! 整数
integer a

! 浮点数
! 单精度浮点数
real a
rea*4 a
! 双精度浮点数
real*8 a

! 复数
complex a

! 字符及字符串
CHARACTER a	! 单个字符
CHARACTER(10) a	! 长度为10的字符串
CHARACTER*10 a
CHARACTER*(10) a
CHARACTER(LEN=10) a
~~~

### DEMO 示例

~~~fortran
! demo
PROGRAM xxxx
IMPLICIT NONE
INTEGER INT1, INT2 宣告区
REAL REAL1, REAL2
READ(*,*) INT1, INT2 程序主体
WRITE (*,*) INT1+INT2
……………………….
STOP
END
~~~

### if

~~~fortran
IF(逻辑判断式) THEN
执行动作 1
ELSE
执行动作 2
END IF

SAMPLE5.f90
PROGRAM MAIN
IMPLICIT NONE
REAL HIEGHT
REAL WEIGHT
READ(*,*) HEIGHT
READ(*,*) WEIGHT
IF (WEIGHT > HEIGHT-100) THEN
WRITE(*,*) “TOO FAT!”
ELSE
WRITE(*,*) “UNDER CONTROL”
END IF
STOP
END
~~~



~~~
= = 相等
/ = 不相等
> 大于
> = 大于等于
< 小于
< = 小于等于
.AND. 如果两边式子都成立，整个条件就成立
.OR. 两边的式子只要有一个成立，整个条件就成立
.NOT. 如果后面的式子不成立，整个式子就算成立
.EQV. 两边式子的逻辑运算结果相同时，整个式子就成立
.NEQV. 两边式子的逻辑运算结果不同时，整个式子就成立
~~~

### do

~~~fortran
DO 起始值, 终止值, 累加值
执行程序代码
END DO

DO I=10, 5, -1
WRITE(*,*) I
END DO
~~~

### do…while

~~~fortran
DO 起始值, 终止值, 累加值
执行程序代码
END DO
~~~

### 数组

~~~fortran
integer a(10) !宣告 a 这个数组有 10 个元素
integer , dimension(10) :: a ! 同上，另一种作法
~~~

### 主程序 子程序

~~~fortran
PROGRAM MAIN
IMPLICIT NONE
INTEGER :: A=1
WRITE (*,*) “A 的初始值是”, A
CALLADD(A)
WRITE(*,*) “A 后来的值是”, A
STOP
END
SUBROUTINE ADD(NUM)
IMPLICIT NONE
INTEGER NUM
NUM = NUM + 1
RETURN
END SUBROUTINE
~~~

~~~fortran
PROGRAM MAIN
IMPLICIT NONE
REAL, EXTERNAL:: TRIPPLE
 real:: A=1.38
 WRITE (*,*) "A的初始值是", A
 WRITE (*,*) "呼叫函数",TRIPPLE(A)
 WRITE(*,*) "A 后来的值是", A
 STOP
END
REAL FUNCTION TRIPPLE(NUM)
IMPLICIT NONE
 REAL NUM
 TRIPPLE = NUM * 3
 RETURN
END
~~~

