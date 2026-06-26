assume cs:code, ds:data, ss:stack
;==========================实验10.1显示字符串
data segment
	db 'hello hsl, hello world!',0
	db 'nihao shijie wo shi hsl',0
data ends




stack segment stack
	dw 0,0,0,0,0,0,0,0
stack ends



; 将data段中的每个单词的前4个字母改为大写字母
code segment
start:
	; 1.初始化栈，因为要调用函数
	mov ax, stack
	mov ss, ax
	mov sp, 16

	; 2.初始化寄存器
	call init_reg
	; 3.设置行和列
	mov dl, 1			; 行 0-24
	mov dh, 13			; 列 0-79
	; 4.调用计算列
	call get_col		; 将行与列转化成列号，结果存在bx中

	add bx, bx			; 将列号乘以2，因为每个字符占用2个字节

	mov cl, 10000010b	; 颜色，此处为绿色
	mov si, 0			; 指向字符串首地址的指针

	call showString

	mov ax,4c00H
	int 21h
init_reg:

	mov ax, data
	mov ds, ax

	mov ax, 0B800H
	mov es, ax

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


showString:


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