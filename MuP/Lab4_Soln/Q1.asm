;Digit Freq Counter

.model small
.stack 100h

.data
buffer db 21, ?, 21 dup(?)  ;maxSize, actualSize, duplicate
freq db 10 dup(0)
newline db 13,10,'$'	;13=Carriage Return, 10=Newline character

.code
main proc
    mov ax,@data
    mov ds,ax

    ; buffered input
    mov ah,0Ah
    lea dx,buffer
    int 21h

    ; SI -> first char
    lea si,buffer+2
    mov cl,buffer+1
    xor ch,ch	;Fastest way to clear register

count_loop:
    mov al,[si]
    sub al,'0'
    xor ah,ah
    mov bx,ax
    inc freq[bx]
    inc si
    loop count_loop

    ; print newline
    mov ah,09h
    lea dx,newline
    int 21h

    ; print frequencies
    mov cx,10
    xor si,si

print_loop:
    mov al,freq[si]
    add al,'0'
    mov dl,al
    mov ah,02h
    int 21h

    mov dl,' '
    int 21h

    inc si
    loop print_loop

    mov ax,4C00h
    int 21h
main endp
end main
