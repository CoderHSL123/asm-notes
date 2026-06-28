assume cs:code, ds:data, ss:stack
;==========================实验11编写子程序
;编写一个子程序，将包含任意字符，
;以0结尾的字符串中的小写字母转变成大写字母

data segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0

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

	; 3.调用子程序
	call letterc


	; 4.退出程序
	mov ax,4c00H
	int 21h


;==========================初始化寄存器
init_reg:
	mov ax, data
	mov ds, ax

	mov si, 0

	ret




;==========================将字符串中的小写字母转变成大写字母
letterc:
	; 通过si依次取出每个字符，判断字符是否是小写字母
	; 如果是小写字母，就将其转换为大写字母
	; 如果不是小写字母，就直接跳过
	; 最后，将转换后的字符串放回data段

	mov al, ds:[si]
	; 判断该字符是否是结束符
	cmp al, 0
	je retFunc
	
	cmp al, 'a'
	jb notSmallLetter
	cmp al, 'z'
	ja notSmallLetter
	sub al, 'a' - 'A'
	; 将转换后的字符放回data段
	mov ds:[si], al
notSmallLetter:
	inc si
	jmp letterc

retFunc:

	; 退出子程序
	ret


code ends

end start