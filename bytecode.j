.source code.in
.class public test
.super java/lang/Object

.method public <init>()V
aload_0
invokenonvirtual java/lang/Object/<init>()V
return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 100
.limit stack 100
iconst_0
istore 1
fconst_0
fstore 2
.line 1
iconst_0
istore 3
L_0:
iconst_0
istore 4
L_1:
ldc 100
istore 3
L_2:
ldc 50
istore 4
L_3:
iconst_0
istore 5
L_4:
ldc 51
istore 5
L_5:
iconst_0
istore 6
L_6:
iload 3
ldc 100
if_icmpeq L_7
ldc 0
goto L_8
L_7:
ldc 1
L_8:
istore 6
L_9:
iload 6
L_10:
L_11:
iload 6
ldc 0
if_icmpeq L_15
goto L_12
L_12:
iload 3
iload 4
iload 5
iadd
if_icmplt L_13
goto L_15
L_13:
iload 4
iload 5
if_icmpgt L_15
goto L_14
L_14:
ldc 2
istore 3
goto L_16
L_15:
iload 3
ldc 3
iadd
istore 3
L_16:
L_17:
L_18:
L_19:
L_20:
L_21:
iload 3
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
return
.end method
