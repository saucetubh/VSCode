;q1
.model small                      ; small memory model (single data/code segment)
.stack 100h                       ; allocate stack space

.data
inName    db "INPUT.TXT",0        ; input file name (ASCIIZ)
outName   db "OUTPUT.TXT",0       ; output file name (ASCIIZ)
lineBuf   db 200 dup(0)           ; buffer to store one input line
byteIn    db 0                    ; temporary storage for one read byte
inH       dw ?                    ; input file handle
outH      dw ?                    ; output file handle
count     dw 0                    ; line counter (word)
numBuf    db 6 dup(0)             ; stores ASCII number
colonSpc  db ": "                 ; stores ": "
crlf      db 13,10                ; CRLF to write after each line

.code
start:
    mov ax,@data                  ; load data segment address
    mov ds,ax                     ; initialize DS

    ; --- open INPUT.TXT for reading ---
    mov ah,3Dh                    ; INT 21h function 3Dh = open file
    mov al,0                      ; AL=0 -> read-only
    lea dx,inName                 ; DX -> filename
    int 21h                       ; call DOS
    jc exit                       ; if failed, exit
    mov inH,ax                    ; store file handle

    ; --- create OUTPUT.TXT ---
    mov ah,3Ch                    ; INT 21h function 3Ch = create file
    mov cx,0                      ; normal file attribute
    lea dx,outName                ; DX -> filename
    int 21h
    jc exit                       ; if failed, exit
    mov outH,ax                   ; store output handle

main_loop:
    xor si,si                     ; SI = length of current line

read_byte:
    mov ah,3Fh                    ; Read 1 byte
    mov bx,inH
    mov cx,1
    lea dx,byteIn
    int 21h
    or ax,ax                      ; 0 bytes read?
    jz check_eof                  ; Yes, EOF reached

    mov al,byteIn
    cmp al,13                     ; Ignore CR (Carriage Return)
    je read_byte
    cmp al,10                     ; LF = end of line
    je write_line

    mov [lineBuf+si],al           ; Store character in buffer
    inc si                        ; Increment length
    jmp read_byte

check_eof:
    cmp si,0                      ; Output remaining chars if EOF isn't clean
    je finish                    

write_line:
    inc count                     ; Increment line counter

    ; --- Convert count to ASCII string ---
    mov ax,count
    mov bx,10
    lea di,numBuf+5               ; Point to end of numBuf
    mov cx,0                      ; CX = Digit logic counter

convert_loop:
    xor dx,dx
    div bx                        ; AX = AX/10, DX = remainder
    add dl,'0'                    ; Convert remainder to ASCII digit
    dec di
    mov [di],dl                   ; Store digit backwards
    inc cx
    cmp ax,0
    jne convert_loop

    ; 1. Write the line number string
    mov ah,40h                    ; INT 21h function 40h = Write file
    mov bx,outH
    mov dx,di                     ; DX points to first digit (computed backwards)
    ; CX conveniently holds exactly the number of digits!
    int 21h

    ; 2. Write ": "
    mov ah,40h
    mov bx,outH
    lea dx,colonSpc
    mov cx,2
    int 21h

    ; 3. Write the actual line contents
    mov ah,40h
    mov bx,outH
    lea dx,lineBuf
    mov cx,si                     ; SI conveniently holds exactly the line length!
    cmp cx,0
    je write_crlf                 ; Skip writing if line length is 0 (empty line)
    int 21h

write_crlf:
    ; 4. Write CRLF (Newline)
    mov ah,40h
    mov bx,outH
    lea dx,crlf
    mov cx,2
    int 21h

    jmp main_loop

finish:
    ; --- close both files ---
    mov ah,3Eh                    ; Close input
    mov bx,inH
    int 21h
   
    mov ah,3Eh                    ; Close output
    mov bx,outH
    int 21h

exit:
    mov ah,4Ch                    ; Terminate program
    xor al,al
    int 21h

end start        


