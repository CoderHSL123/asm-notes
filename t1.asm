assume cs:code,ds:data,ss:stack

data segment
	a db 1,2,3,4,5,6,7,8 ; 数据标号a：字节单元，起始地址：data:0
	b dw 0			  	 ; 数据标号b：字单元，起始地址：data:8
	c dw a,b			 ; 将标号地址作为数据存储，相当于dw offset a, offset b
						 ; 若使用双字存储（如'dd a,b'），会保存偏移地址和段地址
data ends


stack segment stack
	db 128 dup(0)
stack ends





code segment

start:
		mov ax,data 	; 补全，设置ds段寄存器为data段的段地址，方便访问data段中的数据
		mov ds,ax		; 必须显示设置，否则会报错
		mov ax,stack
		mov ss,ax
		mov sp,128
		
		mov si,0
		mov cx,8
calculate:
		mov al,a[si]	; 访问data段数据 mov al,es:[si]
		mov ah,0
		add b,ax
		inc si
		loop calculate

		mov ax,4C00H
		int 21H

;============显示内容的代码=============
show:
		mov ax,0b800h
		mov es,ax
		mov al,39h
		mov byte ptr es:[12*160+40*2], al ;屏幕显示感叹号
		ret


code ends


end start