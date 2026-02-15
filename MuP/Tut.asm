.model small
.stack 100H

.data
    str db 255
        db ?
        db 255 dup(?)    

.code
main proc
    mov ax,@data
    mov ds,ax

    mov ah,0ah
    lea dx,str
    int 21h
    xor cx,cx
    mov cl,str[1]
    mov si,2
    convert:
        cmp str[si],'a'
        jb skip
        cmp str[si],'z'
        ja skip
        mov al,str[si]
        sub al,20h
        mov str[si],al
    skip: 
        inc si
    loop convert

    xor bx,bx
    mov bl,str[1]
    mov str[bx+2],'$'

    mov ah,09h
    lea dx,str+2 ;with lea use +
    int 21h

    mov ah,4ch
    int 21h
main endp
end main

