.model small
.stack 100H

.data
scoreBuf db 100 dup(0)
scoreLen dw ?
typeBuf db 100 dup(0)
typeLen dw ?
newLine db 13,10
fileName db 100 dup(0)
infile db 'LOG.TXT',0
inHandle dw ?
outHandle dw ?
char db ?
Q db '[Q] '
M db '[M] '

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
    lea di,typeBuf
    call read
    mov typeLen,cx

    call skip
    cmp ax,0
    je close
    lea di,fileName
    call read
    call append_txt

    call skip
    cmp ax,0
    je close
    lea di,scoreBuf
    call read
    mov scoreLen,cx

    call write
    jmp start

    close: 
    mov ah,3Eh
    mov bx,inHandle
    int 21h

    exit:
    mov ah,4Ch
    int 21h
main endp

skip proc
    begin:
    mov ah,3Fh
    mov bx,inHandle
    mov cx,1
    lea dx,char
    int 21h 

    cmp ax,0
    je eof

    cmp char,' '
    je found

    jmp begin

    eof:
        mov ax,0
        ret
    found:
        mov ax,1
        ret
skip endp

read proc
    xor cx,cx

    count:
    push cx
    mov ah,3Fh
    mov bx,inHandle
    mov cx,1
    lea dx,char
    int 21h
    pop cx

    cmp ax,0
    je done

    mov al,char
    cmp al,13
    je count
    cmp al,10
    je done

    mov [di],al
    inc cx
    inc di
    jmp count

    done:
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
    lea dx,fileName
    int 21h
    jnc opened

    mov ah,3Ch
    mov cx,0
    lea dx,fileName
    int 21h
    jc fail

    opened:
    mov outHandle,ax

    mov ah,42h
    mov al,2
    mov bx,outHandle
    xor cx,cx
    xor dx,dx
    int 21h

    cmp typeBuf,'M'
    je midsem

    quiz:
    mov ah,40h
    mov bx,outHandle
    mov cx,4
    lea dx,Q 
    int 21h

    jmp next

    midsem:
    mov ah,40h
    mov bx,outHandle
    mov cx,4
    lea dx,M 
    int 21h

    next:
    mov ah,40h
    mov bx,outHandle
    mov cx,scoreLen
    lea dx,scoreBuf
    int 21h

    mov ah,40h
    mov bx,outHandle
    mov cx,2
    lea dx,newLine
    int 21h

    mov ah,3Eh
    mov bx,outHandle
    int 21h

    fail:
        ret
write endp
end main 