assume cs:code, ds:data, ss:stack

data segment
	db 'welcome to masm!'
data ends




stack segment stack
	dw 0,0,0,0,0,0,0,0
stack ends



; 将data段中的每个单词的前4个字母改为大写字母
code segment

	mov ax, data
	mov ds, ax

	mov ax, 0B800H
	mov es, ax

	; 将data段中的字符输出到屏幕
	mov si, 0
	; 向25 * 80的屏幕中间写入字符串  25是行数，80是列数
	; 写入的位置应为40行，12列
	mov di, (12*80 + 32 -1) * 2

	mov ah, 00000010b
	mov cx, 16

printChar:
	mov al, ds:[si]
	mov es:[di], ax
	inc si
	add di, 2
	loop printChar

	mov ax,4c00H
	int 21h

start:
; 使用retf指令修改cs:ip，使其返回到code segment开始执行程序
	mov ax, cs
	push ax

	mov ax, 0
	push ax
	retf
code ends

end start