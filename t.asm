assume cs:code, ds:data, ss:stack

data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982'
	db '1983','1984','1985','1986','1987','1988','1989','1990'
	db '1991','1992','1993','1994','1995'
	; 以上是21年的21个字符串
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	; 以上是21年间每年的总收入
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	; 以上是21年间每年的雇员人数
data ends

table segment
	db 21 dup('year sumn ne ?? ')
table ends



stack segment stack
	dw 0,0,0,0,0,0,0,0
stack ends



; 将data段中的每个单词的前4个字母改为大写字母
code segment
start:
	mov ax, data
	mov ds, ax

	mov ax, stack
	mov ss, ax
	mov sp, 10h

	mov ax, table
	mov es, ax

	mov si, 0
	mov bx, 0	; 代表数据项的起始地址
	mov bp, 0	; 代表table的行
	mov di, 0	; 代表雇员人数的下标
	add di, 0
	mov cx, 21
process:
	; 复制年
	push cx
	; 按字节复制年
	mov cx, 4
	mov si, 0
copyYear:
	mov al, ds:[bx + si]
	mov es:[bp + si], al
	inc si
	loop copyYear




	; 复制总收入
	mov si, 0
	mov cx, 4
copyIncome:
	mov al, ds:[bx + 21*4 + si]
	mov es:[bp + 5 + si], al
	inc si

	loop copyIncome

	; 复制雇员人数

		; 雇员人数直接以字为单位进行复制
	mov ax, ds:[42*4 + di]
	mov es:[bp + 10], ax


	; 计算平均工资
	mov ax, es:[bp + 5]
	mov dx, es:[bp + 7]
	div word ptr es:[bp + 10]
	mov es:[bp + 0dh], ax

	add di, 2
	add bx, 4
	add bp, 16
	pop cx
	loop process


	mov ax,4c00H
	int 21h
code ends

end start