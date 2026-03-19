.model small
.stack 100H

.data
markBuf db 100 dup(0)
markLen dw ?
subjBuf db 100 dup(0)
subjLen dw ?
col db ':'
newLine db 13,10
fileName db 100 dup(0)
infile db 'INPUT.TXT',0
inHandle dw ?
outHandle dw ?
char db ?

.code 
main proc 
    mov ax,@data
    mov ds,ax
    mov ah,3Dh
    mov al,0
    lea dx,infile
    int 21h
    jc exit
    mov inHandle,ax 
    start:
        call skip
        cmp ax,0
        je close
        lea di,subjBuf
        call read
        mov subjLen,cx
        call skip
        cmp ax,0
        je close
        lea di,fileName
        call read
        call append_txt
        call skip
        cmp ax,0
        je close
        lea di,markBuf
        call read
        mov markLen,cx
        call write
        jmp start
    close: 
        mov ah,3Eh
        mov bx,inHandle
        int 21h
    exit:
        xor al,al
        mov ah,4Ch 
        int 21h
main endp

skip proc
    start1:
    mov ah,3Fh
    mov bx,inHandle
    mov cx,1
    lea dx,char
    int 21h
    cmp ax,0
    je fail 
    cmp char, ' '
    je success 
    jmp start1
    fail:
        mov ax,0
        ret
    success:
        mov ax,1
        ret
skip endp

read proc
    xor cx,cx
    start2:
    push cx
    mov ah,3Fh
    mov bx,inHandle
    mov cx,1
    lea dx,char
    int 21h
    pop cx
    cmp ax,0
    je finish
    mov al,char
    cmp al,13
    je start2
    cmp al,10
    je finish
    mov [di],al
    inc di
    inc cx
    jmp start2
    finish:
        ret
read endp

append_txt proc
    mov byte ptr [di],'.'
    mov byte ptr [di+1],'T'
    mov byte ptr [di+2],'X'
    mov byte ptr [di+3],'T'
    mov byte ptr [di+4],0
    ret
append_txt endp

write proc 
    mov ah,3Dh
    mov al,2
    lea dx,filename
    int 21h 
    jnc success1

    mov ah,3Ch
    mov cx,0
    lea dx,filename
    int 21h
    jc exit1

    success1:
    mov outHandle,ax

    mov ah,42h
    mov al,2
    xor cx,cx
    xor dx,dx
    mov bx,outHandle
    int 21h

    xor al,al
    mov ah,40h
    mov bx,outHandle
    mov cx,subjLen
    lea dx,subjBuf
    int 21h

    xor al,al
    mov ah,40h
    mov bx,outHandle
    mov cx,1
    lea dx,col
    int 21h

    xor al,al
    mov ah,40h
    mov bx,outHandle
    mov cx,markLen
    lea dx,markBuf
    int 21h

    xor al,al
    mov ah,40h
    mov bx,outHandle
    mov cx,2
    lea dx,newLine
    int 21h

    mov ah,3Eh
    mov bx,outHandle
    int 21h

    exit1:
        ret
write endp
end main 