.model small
.stack 100h

.data
	msg1 db 'Input Num1:','$'
	msg2 db 'Input Num2:','$'
	msg3 db 'Output:','$'
	newline db 13,10,'$'
	num1 db 4
		 db ?
		 db 4 dup(?)
	num2 db 4
		 db ?
		 db 4 dup(?)
	n1 db 0
	
.code
main proc
	mov ax,@data
	mov ds,ax
	
	mov ah,09h
	lea dx,msg1
	int 21h
	
	mov ah,0ah
	lea dx,num1 
	int 21h
	
	mov ah,09h
	lea dx,newline
	int 21h
	lea dx,msg2
	int 21h
	
	mov ah,0ah
	lea dx,num2 
	int 21h
	
	mov ah,09h
	lea dx,newline
	int 21h
	lea dx,msg3
	int 21h
	
	xor cx,cx
	mov cl,num1[1]
	xor ax,ax
	mov si,2
	mov bl,10
	convert:	
		mul bl
		mov dl,num1[si]
		sub dl,'0'
		add al,dl
		inc si
	loop convert
	mov n1,al
	
	xor cx,cx
	mov cl,num2[1]
	xor ax,ax
	mov si,2
	mov bl,10
	convert2:	
		mul bl
		mov dl,num2[si]
		sub dl,'0'
		add al,dl
		inc si
	loop convert2
	
	add al,n1 ;al now contains the sum
	mov bl,10
	mov si,0
	
	mov cx,0
	convert3:
	mov ah,0
	div bl
	push ax
	inc cx
	cmp al,0
	jne convert3
	
	print:
	pop dx
	mov dl,dh
	add dl,'0'
	mov ah,02h
	int 21h
	loop print
	
	mov ah,4ch
	int 21h
main endp
end main


;ascii to number and number to ascii covered for general case (max integer 255 assumed)