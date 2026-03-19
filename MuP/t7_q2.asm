;question 2

.model small                  ; define small memory model
.stack 100h                   ; allocate 256 bytes for stack

.data                         ; start of data segment
inFile    db "INPUT.TXT",0    ; null-terminated input file name
inHand    dw ?                ; word variable to store input file handle
outHand   dw ?                ; word variable to store output file handle
charIn    db ?                ; byte variable for single character read

subjBuf   db 100 dup(0)       ; 100-byte buffer to store the subject string
subjLen   dw ?                ; word variable to store subject string length
fileBuf   db 100 dup(0)       ; 100-byte buffer to store dynamic filename (e.g. "s1.TXT")
markBuf   db 100 dup(0)       ; 100-byte buffer to store the mark string
markLen   dw ?                ; word variable to store mark string length

colonOut  db ":"              ; single byte character to print ":"
crlf      db 13,10            ; Carriage Return, Line Feed characters for newline

.code                         ; start of code segment
start:                        ; main program entry point
    mov ax, @data             ; load data segment address into AX
    mov ds, ax                ; initialize data segment register DS

    ; --- Open INPUT.TXT for reading ---
    mov ah, 3Dh               ; DOS function 3Dh: open existing file
    mov al, 0                 ; AL = 0 for read-only access mode
    lea dx, inFile            ; load effective address of input filename into DX
    int 21h                   ; trigger DOS interrupt to open file
    jnc open_ok               ; jump to open_ok if carry flag is clear (success)
    jmp exit                  ; if carry flag is set, file not found, jump to exit

open_ok:                      ; label for successful file open
    mov inHand, ax            ; save the file handle returned in AX to inHand variable

read_record:                  ; label to start reading a new 3-line record
    ; ========================================================
    ; 1. Process "Subject: <subject>" line
    ; ========================================================
    call skip_to_space        ; call procedure to skip characters until a space is found
    cmp ax, 0                 ; check if AX is 0 (indicating End of File)
    je close_input            ; if EOF reached, jump to close_input
    lea di, subjBuf           ; load effective address of subject buffer into DI
    call read_until_nl        ; call procedure to read the rest of the line until newline
    mov subjLen, cx           ; store the length of the read subject string (from CX) into subjLen

    ; ========================================================
    ; 2. Process "Student: <student_id>" line
    ; ========================================================
    call skip_to_space        ; call procedure to skip characters until a space is found
    cmp ax, 0                 ; check if AX is 0 (indicating End of File)
    je close_input            ; if EOF reached, jump to close_input
    lea di, fileBuf           ; load effective address of file buffer into DI
    call read_until_nl        ; call procedure to read the student ID until newline
    call append_txt           ; call procedure to append ".TXT" to the student ID

    ; ========================================================
    ; 3. Process "Marks: <marks>" line
    ; ========================================================
    call skip_to_space        ; call procedure to skip characters until a space is found
    cmp ax, 0                 ; check if AX is 0 (indicating End of File)
    je close_input            ; if EOF reached, jump to close_input
    lea di, markBuf           ; load effective address of marks buffer into DI
    call read_until_nl        ; call procedure to read the marks until newline
    mov markLen, cx           ; store the length of the read marks string (from CX) into markLen

    ; ========================================================
    ; 4. Format and append data to the student's file
    ; ========================================================
    call append_record        ; call procedure to write the formatted record to the student's file
    jmp read_record           ; loop back to read the next record


close_input:                  ; label to handle closing the input file
    mov ah, 3Eh               ; DOS function 3Eh: close file
    mov bx, inHand            ; load input file handle into BX
    int 21h                   ; trigger DOS interrupt to close file

exit:                         ; label to handle program termination
    mov ah, 4Ch               ; DOS function 4Ch: terminate program
    xor al, al                ; clear AL for exit code 0
    int 21h                   ; trigger DOS interrupt to exit

; ================== PROCEDURES ==================

; ========================================================
; Skips characters until it finds a space (' ')
; Returns AX = 1 if successful, AX = 0 if EOF
skip_to_space proc            ; start of skip_to_space procedure
skip_lp:                      ; label for skip loop
    mov ah, 3Fh               ; DOS function 3Fh: read from file
    mov bx, inHand            ; load input file handle into BX
    mov cx, 1                 ; set CX to 1 byte to read
    lea dx, charIn            ; load effective address of character buffer into DX
    int 21h                   ; trigger DOS interrupt to read 1 byte
    or ax, ax                 ; logically OR AX with itself to check for 0 bytes read
    jz skip_eof               ; if zero bytes read (EOF), jump to skip_eof
    cmp charIn, ' '           ; compare read character with space (' ')
    je skip_found             ; if it is a space, jump to skip_found
    jmp skip_lp               ; otherwise, jump back to skip_lp to keep reading
skip_eof:                     ; label for EOF condition
    mov ax, 0                 ; set AX to 0 indicating failure/EOF
    ret                       ; return from procedure
skip_found:                   ; label for space found condition
    mov ax, 1                 ; set AX to 1 indicating success
    ret                       ; return from procedure
skip_to_space endp            ; end of skip_to_space procedure

; ========================================================
; Reads characters until Newline (LF) or EOF is encountered.
; Ignores Carriage Return (CR).
; Input: DI points to the target destination buffer
; Output: CX = length of characters read
read_until_nl proc            ; start of read_until_nl procedure
    xor cx, cx                ; clear CX to reset length counter to 0
nl_lp:                        ; label for newline read loop
    push cx                   ; save CX onto stack because int 21h might modify it
    mov ah, 3Fh               ; DOS function 3Fh: read from file
    mov bx, inHand            ; load input file handle into BX
    mov cx, 1                 ; set CX to 1 byte to read
    lea dx, charIn            ; load effective address of character buffer into DX
    int 21h                   ; trigger DOS interrupt to read 1 byte
    pop cx                    ; restore CX from stack
    or ax, ax                 ; logically OR AX with itself to check for 0 bytes read
    jz nl_end                 ; if zero bytes read (EOF), jump to nl_end
    mov al, charIn            ; load read character into AL
    cmp al, 13                ; compare AL with 13 (Carriage Return)
    je nl_lp                  ; if Carriage Return, ignore and jump back to read next byte
    cmp al, 10                ; compare AL with 10 (Line Feed)
    je nl_end                 ; if Line Feed, end of line reached, jump to nl_end
    mov [di], al              ; store characters read into buffer pointed to by DI
    inc di                    ; increment DI to point to next buffer position
    inc cx                    ; increment CX length counter
    jmp nl_lp                 ; jump back to nl_lp to keep reading
nl_end:                       ; label for end of line reading
    ret                       ; return from procedure
read_until_nl endp            ; end of read_until_nl procedure

; ========================================================
; Converts the raw student ID into a proper DOS file name
; Input: CX = length of student ID. DI is manipulated.
append_txt proc               ; start of append_txt procedure
    lea di, fileBuf           ; load effective address of file name buffer into DI
    add di, cx                ; add string length to DI to point to the end of the string
    mov byte ptr [di], '.'    ; write '.' at the current DI position
    mov byte ptr [di+1], 'T'  ; write 'T' at next position
    mov byte ptr [di+2], 'X'  ; write 'X' at next position
    mov byte ptr [di+3], 'T'  ; write 'T' at next position
    mov byte ptr [di+4], 0    ; write null terminator at next position
    ret                       ; return from procedure
append_txt endp               ; end of append_txt procedure

; ========================================================
; Opens (or creates) file, seeks to end, and writes record
append_record proc            ; start of append_record procedure
    ; 1. Try Opening the file (AL=2 is Read/Write)
    mov ah, 3Dh               ; DOS function 3Dh: open file
    mov al, 2                 ; AL = 2 for Read/Write mode
    lea dx, fileBuf           ; load effective address of filename buffer into DX
    int 21h                   ; trigger DOS interrupt to open file
    jnc opened_ok             ; if carry flag clear, file opened successfully, jump to opened_ok
    
    ; 2. If it did not exist, Create it (Normal attribute)
    mov ah, 3Ch               ; DOS function 3Ch: create file
    mov cx, 0                 ; CX = 0 for normal file attribute
    lea dx, fileBuf           ; load effective address of filename buffer into DX
    int 21h                   ; trigger DOS interrupt to create file
    jc write_done             ; if carry flag set, error creating file, jump to write_done (abort)
    
opened_ok:                    ; label for successfully opened or created file
    mov outHand, ax           ; save returned file handle from AX to outHand variable
    
    ; 3. Move File Pointer to End of File (Append mode)
    mov ah, 42h               ; DOS function 42h: move file pointer (lseek)
    mov al, 2                 ; AL = 2 move pointer relative to end of file
    mov bx, outHand           ; load output file handle into BX
    xor cx, cx                ; clear CX to set high word of offset to 0
    xor dx, dx                ; clear DX to set low word of offset to 0
    int 21h                   ; trigger DOS interrupt to move file pointer
    
    ; 4. Write: "<subject>"
    mov ah, 40h               ; DOS function 40h: write to file
    mov bx, outHand           ; load output file handle into BX
    mov cx, subjLen           ; load subject string length into CX
    lea dx, subjBuf           ; load effective address of subject buffer into DX
    int 21h                   ; trigger DOS interrupt to write subject string
    
    ; 5. Write: ":"
    mov ah, 40h               ; DOS function 40h: write to file
    mov cx, 1                 ; set CX to 1 byte to write
    lea dx, colonOut          ; load effective address of colon character into DX
    int 21h                   ; trigger DOS interrupt to write colon
    
    ; 6. Write: "<marks>"
    mov ah, 40h               ; DOS function 40h: write to file
    mov cx, markLen           ; load marks string length into CX
    lea dx, markBuf           ; load effective address of marks buffer into DX
    int 21h                   ; trigger DOS interrupt to write marks string
    
    ; 7. Write: CRLF (Newline)
    mov ah, 40h               ; DOS function 40h: write to file
    mov cx, 2                 ; set CX to 2 bytes to write (CR, LF)
    lea dx, crlf              ; load effective address of CRLF bytes into DX
    int 21h                   ; trigger DOS interrupt to write newline
    
    ; 8. Close the Output File
    mov ah, 3Eh               ; DOS function 3Eh: close file
    mov bx, outHand           ; load output file handle into BX
    int 21h                   ; trigger DOS interrupt to close output file
    
write_done:                   ; label for end of writing process
    ret                       ; return from procedure
append_record endp            ; end of append_record procedure

end start                     ; end of program source, specifying entry point start
