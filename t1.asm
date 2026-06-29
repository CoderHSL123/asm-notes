assume cs:code, ds:data, ss:stack
; 出现除法错误的时候，触发中断执行我们定义的函数
; 修改中断向量表的0号中断向量，指向我们定义的函数

data segment
	db 'over flow!', 0
	db 16 dup(0)

data ends



stack segment stack
	dw 16 dup(0)
stack ends



code segment
	; 中断处理程序

interruptFunc:
displayString:
	mov ch, 0
	mov cl, ds:[si]
	jcxz funcRet
	mov ch, 00000010b	; 设置字符为黑底绿字
	mov es:[di], cx
	add di, 2
	inc si
	jmp short displayString

funcRet:
	; 返回dos系统
	mov ax, 4c00h
	int 21h


start:
	; 1.初始化栈，因为要调用函数
	mov ax, stack
	mov ss, ax
	mov sp, 32

	; 2.初始化寄存器
	call init_reg

	; 3.修改中断向量表的0号中断向量，指向我们定义的函数
	call modify_ivt

	; 4.执行一个除法错误
	mov ax, 1000
	mov bl, 0
	div bl

	; 5.退出程序
	mov ax,4c00H
	int 21h


;==========================初始化寄存器
init_reg:
	mov ax, data
	mov ds, ax
	mov ax, 0B800H
	mov es, ax
	mov si, 0	; 代表字符串的起始地址
	mov di, 880	; 在终端显示的列的位置，记得要乘以2，因为每个字符占用2个字节
	ret




;==========================修改中断向量表的0号中断向量，指向我们定义的函数
modify_ivt:
	push ds
	mov ax, 0
	mov ds, ax
	; ip的地址
	mov word ptr ds:[0], offset interruptFunc
	; cs的地址
	mov ax, code
	mov ds:[0+2], ax
	pop ds
	ret


code ends

end start