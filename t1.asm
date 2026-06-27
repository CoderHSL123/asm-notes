assume cs:code, ds:data, ss:stack
;==========================实验10.3数值显示

data segment
	dw 32145
	db 14 dup(0)
	db 16 dup(0)

data ends



stack segment stack
	dw 16 dup(0)
stack ends



code segment
start:
	; 1.初始化栈，因为要调用函数
	mov ax, stack
	mov ss, ax
	mov sp, 32

	; 2.初始化寄存器
	call init_reg

	call convertNumToString

	; 将栈中的数据弹出，存入数据段中
	call popStack
	; 3.调用函数显示字符串
	call displayString

	; 4.退出程序
	mov ax,4c00H
	int 21h

;====================初始化寄存器
init_reg:

	mov ax, data
	mov ds, ax
	mov ax, 0B800H
	mov es, ax


	mov si, 0
	ret

;======================将数字转换为字符串存入栈中
convertNumToString:
	; 保存栈顶地址
	mov bp, sp
	mov ax, data
	mov ss, ax
	mov sp, 32


	mov bx, 10
	mov ax, ds:[si]  		; 从数据段中获取数字 低位
	mov dx, 0				; 从数据段中获取数字 高位

traverseBit:
	div bx
	; 根据商是否为0，判断是否已经遍历完所有位
	mov cx, ax
	; 将余数转换为字符
	add dx, 48
	push dx
	inc byte ptr ds:[2]
	jcxz done
	mov dx, 0				; 清空余数寄存器
	jmp short traverseBit

done:
	; 保存ds部分的栈顶地址
	mov ds:[4], sp
	; 恢复栈顶地址
	mov sp, bp
	mov ax, stack
	mov ss, ax

	ret
;======================将栈中的数据弹出，存入数据段中
popStack:
	mov cx, ds:[2]
	mov si, 16

	mov bp, sp
	mov ax, data
	mov ss, ax
	; 恢复ds部分的栈顶地址
	mov sp, ds:[4]

	; 输出每个字符到屏幕
loopBit:
	pop ax
	mov ds:[si], al
	inc si
	loop loopBit

	mov byte ptr ds:[si], 0	; 字符串的结束标志
	mov sp, bp
	mov ax, stack
	mov ss, ax
	ret

;======================显示字符串
displayString:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp

	mov dl, 4	; 行
	mov dh, 40	; 列

	call get_col
	add bx, bx			; 将列号乘以2，因为每个字符占用2个字节

	mov cl, 10000010b	; 颜色，此处为绿色
	mov si, 10H			; 指向字符串首地址的指针

	call ShowString

	pop bp
	pop si
	pop di
	pop cx
	pop dx
	pop bx
	pop ax

	ret

;===================计算行对应的列数，将结果存入bx中
get_col:
	mov al, dl
	mov ah, 80
	mul ah
	mov dl, dh
	mov dh, 0
	add ax, dx
	mov bx, ax
	ret

ShowString:

	mov ah, cl				; 保存颜色属性
putChar:
	mov ch, 0
	mov cl, ds:[si]			; 获取要输出的字符
	jcxz retFunc			; 如果cx为0，那么就说明到了字符串的结束，返回函数

	mov es:[bx], cl			; 显示字符
	mov es:[bx+1], ah		; 显示颜色属性
	inc si
	add bx, 2
	jmp short putChar


retFunc:
	ret



code ends

end start