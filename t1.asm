assume cs:code, ds:data, ss:stack
; 修改现有的9号中断向量，
; 使其在键盘按下esc键后，更改整个屏幕的颜色

data segment
	db 16 dup(0)
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

	; 3.保存原来中断向量的IP CS
	mov ax, 0
	mov ds, ax

	push ds:[9 * 4 + 2]			; 保存CS
	push ds:[9 * 4]				; 保存IP
	; 恢复ds寄存器指向data段
	mov ax, data
	mov ds, ax

	pop ds:[0]					; 保存IP
	pop ds:[2]					; 保存CS

	; 4.修改9号中断向量
	mov ax, 0
	mov ds, ax
	mov bx, offset int9
	mov ds:[9 * 4], bx				; 修改IP
	mov ds:[9 * 4 + 2], cs			; 修改CS

	mov ax, data
	mov ds, ax

	; 打印字母表
	mov ah, 'a'
printAlphabet:
	mov es: [160 *12 + 40 *2], ah
	call delay
	inc ah
	cmp ah, 'z'
	jna printAlphabet


	; 5.退出程序
	mov ax,4c00H
	int 21h


;==========================初始化寄存器
init_reg:
	mov ax, data
	mov ds, ax

	mov ax, 0B800H
	mov es, ax
	

	ret



int9:
	; 1.保存上下文寄存器
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp


	in al, 60h
	push ax
	pushf
	call dword ptr ds:[0]
	pop ax
	; 比较是否是esc键
	cmp al, 01h
	jne continue

	; 修改4000个单元的颜色
	mov cx, 2000
	mov bx, 1
changeColor:
	; 修改颜色
	inc byte ptr es:[bx]
	add bx, 2
	loop changeColor



continue:
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	iret


delay:
	push ax
	push dx
	mov dx, 10h
	mov ax, 0h
s1:
	sub ax, 1
	sbb dx, 0
	cmp ax, 0
	jne s1

	cmp dx, 0
	jne s1

	pop dx
	pop ax
	ret


code ends

end start