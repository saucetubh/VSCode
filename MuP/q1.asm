.model small
.stack 100h

.data
	msg1 db 'Input Number:','$'
	msg2 db 'Output:','$'
	newline db 13,10,'$'
	str db 21,?,21 dup(?)
	res db 10 dup(0)
.code
main proc
	mov ax,@data
	mov ds,ax
		
	mov ah,09h
	lea dx,msg1
	int 21h
	
	mov ah,0ah
	lea dx,str
	int 21h
	
	mov ah,09h
	lea dx,newline
	int 21h
	lea dx,msg2
	int 21h
	
	mov ch,0
	mov cl,str[1]
	mov si,2
	mov bh,0
	count:
		mov bl,str[si]
		sub bl,'0'
		inc res[bx]
		inc si
	loop count
	
	xor cx,cx
	mov cl,10
	mov si,0
	print:
		mov dl,res[si]
		add dl,'0'
		mov ah,02h
		int 21h
		mov dl,' '
		int 21h
		inc si
	loop print
		
	mov ah,4ch
	int 21h
main endp
end main