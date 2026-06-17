assume cs:code,ds:data,ss:stack

;数据段
data segment
	dw 0123H,0456H,0789H,0ABCH,0DEFH,0FEDH,0CBAH,0987H
data ends

stack segment stack
	dw 0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0
stack ends



code segment
;start伪指令将程序入口地址信息记录在最终的exe文件中的描述信息中
;程序启动时会依照描述信息对CS IP寄存器进行设置
start:
		mov ax,stack
		mov ss,ax
		
		mov ax,data
		mov ds,ax

		mov bx,0
		mov cx,8
pushData:
		push ds:[bx]
		add bx,2
		loop pushData

		mov ax,4C00H
		int 21H
		


code ends





end start

