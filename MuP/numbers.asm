.model small
.stack 100h

.data
    sum db 3
        db ?
        db 3 dup(?)
    newline db 13,10,'$'
	msg1 db 'Input Num1:','$'
	msg2 db 'Input Num2:','$'
	msg3 db 'Output:','$'
    num1 db ?
	num2 db ?
	res db ?
	
.code
main proc
    mov ax,@data
    mov ds,ax

	mov ah,09h
	lea dx,msg1
	int 21h
	
	mov ah,01h
	int 21h
	sub al,'0'
	
	mov bl,10
	mul bl
	push ax
	
	xor ax,ax
	mov ah,01h
	int 21h
	sub al,'0'
	
	mov bl,al
	pop ax
	add al,bl
	
	mov num1,al
	
	mov ah,09h
	lea dx,newline
	int 21h
	
	mov ah,09h
	lea dx,msg2
	int 21h
	
	mov ah,01h
	int 21h
	sub al,'0'
	
	mov bl,10
	mul bl
	push ax
	
	xor ax,ax
	mov ah,01h
	int 21h
	sub al,'0'
	
	mov bl,al
	pop ax
	add al,bl
	
	add al,num1
	mov res,al
	
	mov ah,09h
	lea dx,newline
	int 21h
	lea dx,msg3
	int 21h
	
	xor ax,ax
	mov al,res
	mov bl,10
	xor cx,cx
	mov cl,0
	
	divide:
	div bl
	push ax
	inc cl
	mov ah,0
	cmp al,0
	jne divide
	
	print:
	pop dx
	add dh,'0'
	mov dl,dh
	mov ah,02h
	int 21h
	loop print
    
    mov ah,4ch
    int 21h
main endp
end main