.model small
.stack 100H

.data
    ;enter variables declared

.code
main proc
    mov ax,@data
    mov ds,ax

    ;enter main program code

    mov ah,4ch
    int 21h
main endp
end main

;this is boiler plate for masm code, this must always be present

;dealing with input of numbers is annoying so practice that because cpu will treat all input as a char/string
;accordingly convert from ascii to decimal
;if u want to output a number then use repeated division to extract remainder, add 30h and use 02H function
to print that char (use stack - push and pop to display characters in order)
;if u want to process and input number (inputted digit by digit) then use repeated multiplication


;for any given problem first write high level pseudocode then try converting it into assembly code and write in masm


;to bebug masm file do this -
;copy debugx into masm bin folder
;then type debug filename.exe
;then type trace
