mov ax,cs
mov ds,ax
mov es,ax
mov si, 0200
mov di, 0300
lodsb
cmp al,24
jz 0118 
cmp al,20
jz 010C
stosb
jmp 010C
mov al,24
stosb
ret
