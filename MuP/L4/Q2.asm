;Runniing Mean

.model small
.stack 100h

.data
sum     dw 0
count   db 0
newline db 13,10,'$'

.code
main proc
    mov ax,@data
    mov ds,ax

read_loop:
    mov ah,01h
    int 21h

    cmp al,'X'
    je exit

    ; move to new line after input
    mov ah,09h
    lea dx,newline
    int 21h

    sub al,'0'
    cbw
    add sum,ax
    inc count

    ; mean = sum / count
    mov ax,sum
    mov bl,count
    xor bh,bh
    div bl

    ; print mean
    add al,'0'
    mov dl,al
    mov ah,02h
    int 21h

    ; go to next line before waiting for next input
    mov ah,09h
    lea dx,newline
    int 21h

    jmp read_loop

exit:
    mov ax,4C00h
    int 21h
main endp
end main
