.model small
.stack 100H

.data
    newline db 13,10,'$'
    msg1 db 'Input:','$'
    i db 0
    number db 4 ; 4 since one extra character for enter key
           db ?
           db 4 dup(?)
    num db 0

.code
main proc
    mov ax,@data
    mov ds,ax

    mov ah,09h
    lea dx,msg1
    int 21h

    mov ah,0Ah
    lea dx,number
    int 21h

    mov ah,09h
    lea dx,newline
    int 21h

    mov bl,1
    ;processing the number first (converting from ascii string to number)
    mov al,number[1]
    mov ah,0
    mov si,ax
    convert:
    dec si
    xor ax,ax
    mov al,number[si+2]
    sub al,'0'
    mul bl
    add num,al
    mov al,bl
    mov bl,10
    mul bl
    mov bl,al
    cmp si,0
    jne convert

    xor ax,ax
    xor cx,cx

    outerloop:
    inc i
    mov cl,i

    print_star:
    mov ah,02h
    mov dl,'*'
    int 21h
    loop print_star

    print_newline:
    mov ah,09h
    lea dx,newline
    int 21h
    mov bl,num
    cmp i,bl
    jbe outerloop

    mov ah,4ch
    int 21h
main endp
end main

;for integer > 9 , take string input, first convert string of numbers to integer