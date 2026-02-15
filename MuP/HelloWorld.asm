.model small
.stack 100H

.data


.code
main proc
    mov ax,@data
    mov ds,ax


    mov ah,4ch
    int 21h
main endp
end main

