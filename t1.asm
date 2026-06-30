assume cs:code, ds:data, ss:stack
; 修改中断号7CH的中断向量，指向我们定义的函数
; 使的data段中的字符串的所有字符都改为大写字母

data segment
	db 'conversation hello world', 0
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

	; 3.修改中断向量表的0号中断向量，指向我们定义的函数
	call modify_ivt

	; 获得displayStringEnd与displayString的偏移位移，并将结果存放在bx中，
	; 用于后续的中断例程中跳转
	mov bx, offset displayString - offset displayStringEnd
	
	mov ah, 00000010b
displayString:
	mov al, ds:[si]
	cmp al, 0
	je endProgram
	mov es:[di], ax
	add di, 2
	inc si
	int 7CH
displayStringEnd:
	nop


endProgram:
	; 5.退出程序
	mov ax,4c00H
	int 21h


;==========================初始化寄存器
init_reg:
	mov ax, data
	mov ds, ax
	mov si, 0
	
	mov ax,0B800H
	mov es, ax
	mov di, 12 * 160	;从第12行开始显示


	ret




;==========================修改中断向量表的0号中断向量，指向我们定义的函数
modify_ivt:
	push ds
	mov ax, 0
	mov ds, ax
	; ip的地址
	mov word ptr ds:[7ch * 4], offset myNearJmp
	; cs的地址
	mov ax, code
	mov ds:[7ch * 4 + 2], ax
	pop ds
	ret




;==========================使用中断例程函数模拟jmp near ptr跳转
myNearJmp:

	; 将ds段中的字符串显示到终端中
	push bp
	mov bp, sp
	; 计算出的位移增加到IP中
	add word ptr ss:[bp + 2], bx
	mov sp, bp
	pop bp
	iret


code ends

end start