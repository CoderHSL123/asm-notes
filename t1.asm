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

	mov si, 0			; 定义0索引
	mov di, 21*4 + 21*4	; 定义总收入的开始索引

	mov ax, table
	mov es, ax
	mov bp, 0
	mov cx, 21

copyElement:
	; 完成单个年份
	push ds:[si + 0]
	pop es:[bp + 0]
	push ds:[si + 2]
	pop es:[bp + 2]

	; 完成收入复制
	push ds:[si + 21*4 + 0]
	pop es:[bp + 5]
	push ds:[si + 21*4 + 2]
	pop es:[bp + 7]

	; 完成总收入的复制
	push ds:[di]
	pop es:[bp + 10]

	; 计算每年每人的平均工资
	mov ax, es:[bp + 5]
	mov dx, es:[bp + 7]
	div word ptr es:[bp + 10]
	mov es:[bp + 13], ax

	add si, 4
	add di, 2
	add bp, 16
	loop copyElement

	mov ax,4c00H
	int 21h
code ends

end start