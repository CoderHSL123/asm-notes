assume cs:code, ds:data, ss:stack
;==========================实验10.2解决除法溢出问题
; div指令用于做除法，当进行8位除法时，al存储商，ah存储余数
;                   16位除法时，ax存储商，dx存储余数
; 但是如果结果的商大于 al 或者 ax存储的最大值，就会溢出
; 例如100000(32bit)/10(16bit) = 100000(16bit)，结果显然超出了ax的范围
data segment
	db 16 dup(0)
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

	; 3. 计算结果
	call calDivdw


	mov ax,4c00H
	int 21h

;====================初始化寄存器
init_reg:

	mov ax, data
	mov ds, ax
	; 输入被除数和除数
	call inputDivNum


	ret


;====================将被除数和除数放入寄存器中
inputDivNum:
	; 1. 放入被除数
	mov dx, 0FH
	mov ax, 4240H
	; 2. 放入除数
	mov cx, 10

	ret


;==================计算商
calDivdw:
	; 实现的公式 X/N = int(H/N)*65536 + [rem(H/N) * 65536 + L] / N
	; 保存32位被除数

	push ax
	; int(H/N)
	mov ax, dx
	mov dx, 0
	div cx

	; [rem(H/N) * 65536 + L] / N
	mov bx, ax		; 保存商
	pop ax			; 取出低16位
	div cx
	mov dx, bx		; 将高位放回dx
	
	; 保存结果到ds中
	mov word ptr ds:[0], ax
	mov word ptr ds:[2], dx

	ret







	ret

code ends

end start