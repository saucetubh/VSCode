.model small
.stack 100h

.data
	sum db 0
	n db 0
	newline db 13,10,'$'
.code
main proc
	mov ax,@data
	mov ds,ax
	
	input:
	mov ah,08h
	int 21h
	cmp al,'X'
	je finish
	sub al,'0'
	add sum,al
	inc n
	mov ah,0
	mov al,sum
	mov bl,n
	div bl
	mov dl,al
	add dl,'0'
	mov ah,02h
	int 21h
	mov ah,09h
	lea dx,newline
	int 21h
	jmp input
	
	finish:
	mov ah,4ch
	int 21h
main endp
end main