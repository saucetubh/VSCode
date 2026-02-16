.model small
.stack 100H

.data
    newline db 13,10,'$'
    msg1 db 'Input:','$'
    i db 0
    n db ?

.code
main proc
    mov ax,@data
    mov ds,ax

    mov ah,09h
    lea dx,msg1
    int 21h

    mov ah,01h
    int 21h

    mov ah,09h
    lea dx,newline
    int 21h

    sub al,'0'
    mov n,al
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
    mov bl,n
    cmp i,bl
    jbe outerloop

    mov ah,4ch
    int 21h
main endp
end main






pseudocode
for(int i=0;i<=n;i++) {
    for(int j=0;j<=i;j++) {
        print(*);
    }
    print(newline)
}
