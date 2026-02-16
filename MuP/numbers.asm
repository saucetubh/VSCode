.model small
.stack 100h

.data
    sum db 3
        db ?
        db dup(?)
    newline db 13,10,'$'
    
.code
main proc
    mov ax,@data
    mov ds,ax



    mov ah,4ch
    int 21h
main endp
end main