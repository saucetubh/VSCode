# Complete MASM Assembly Programming Tutorial
## From Basics to Your Lab Problems

---

## Table of Contents
1. [Introduction to Assembly Language](#introduction)
2. [MASM Basics & Program Structure](#masm-basics)
3. [Registers and Data Types](#registers)
4. [Instructions and Operations](#instructions)
5. [Input/Output Operations](#io-operations)
6. [Arrays and Memory](#arrays)
7. [Control Flow (Loops & Conditionals)](#control-flow)
8. [Complete Problem Solutions](#solutions)

---

## 1. Introduction to Assembly Language {#introduction}

### What is Assembly Language?
Assembly language is a low-level programming language that provides a symbolic representation of machine code. Each assembly instruction typically corresponds to one machine instruction.

### Why Learn Assembly?
- Understand how computers work at the hardware level
- Write highly optimized code
- Interface with hardware directly
- Better understand high-level programming concepts

### MASM (Microsoft Macro Assembler)
MASM is an x86 assembler for Microsoft Windows. It converts assembly language into machine code.

---

## 2. MASM Basics & Program Structure {#masm-basics}

### Basic Program Structure

```asm
.MODEL SMALL        ; Memory model (TINY, SMALL, MEDIUM, COMPACT, LARGE, HUGE)
.STACK 100H         ; Stack size (100H = 256 bytes)

.DATA               ; Data segment - variables declared here
    ; Variables go here

.CODE               ; Code segment - program instructions
MAIN PROC
    MOV AX, @DATA   ; Initialize data segment
    MOV DS, AX
    
    ; Your code here
    
    MOV AH, 4CH     ; DOS terminate program function
    INT 21H         ; Call DOS interrupt
MAIN ENDP
END MAIN            ; End of program, entry point is MAIN
```

### Memory Models
- **TINY**: Code + Data + Stack ≤ 64KB (used for .COM files)
- **SMALL**: Code ≤ 64KB, Data ≤ 64KB (most common for simple programs)
- **MEDIUM**: Code > 64KB, Data ≤ 64KB
- **COMPACT**: Code ≤ 64KB, Data > 64KB
- **LARGE**: Both Code and Data > 64KB
- **HUGE**: Arrays > 64KB allowed

---

## 3. Registers and Data Types {#registers}

### General Purpose Registers (16-bit)

**AX (Accumulator)**: Primary for arithmetic operations
- AH (high byte), AL (low byte)

**BX (Base)**: Base register for addressing
- BH (high byte), BL (low byte)

**CX (Counter)**: Loop counter
- CH (high byte), CL (low byte)

**DX (Data)**: I/O operations, multiplication/division
- DH (high byte), DL (low byte)

### Segment Registers
- **CS**: Code Segment
- **DS**: Data Segment
- **SS**: Stack Segment
- **ES**: Extra Segment

### Index Registers
- **SI**: Source Index (string operations)
- **DI**: Destination Index (string operations)
- **BP**: Base Pointer (stack frame)
- **SP**: Stack Pointer (top of stack)

### Flags Register
- **CF**: Carry Flag
- **ZF**: Zero Flag
- **SF**: Sign Flag
- **OF**: Overflow Flag
- **PF**: Parity Flag

### Data Types in MASM

```asm
.DATA
    myByte   DB 25          ; Define Byte (8 bits, 0-255)
    myWord   DW 1000        ; Define Word (16 bits, 0-65535)
    myDouble DD 100000      ; Define Doubleword (32 bits)
    
    myChar   DB 'A'         ; Single character
    myString DB 'Hello$'    ; String ($ is terminator for DOS)
    
    myArray  DB 10, 20, 30, 40, 50    ; Byte array
    
    buffer   DB 21 DUP(0)   ; 21 bytes initialized to 0
```

---

## 4. Instructions and Operations {#instructions}

### Data Movement

```asm
MOV dest, source    ; Move data (dest = source)
                    ; Cannot do MOV mem, mem (use register)

LEA reg, memory     ; Load Effective Address (get address)
```

**Examples:**
```asm
MOV AL, 5           ; AL = 5
MOV BL, AL          ; BL = AL
MOV [myByte], AL    ; Store AL in memory location myByte
MOV CX, myWord      ; CX = value at myWord
```

### Arithmetic Operations

```asm
ADD dest, source    ; dest = dest + source
SUB dest, source    ; dest = dest - source
INC dest            ; dest = dest + 1
DEC dest            ; dest = dest - 1

MUL source          ; AX = AL * source (byte) OR DX:AX = AX * source (word)
DIV source          ; AL = AX / source (quotient), AH = AX % source (remainder)
```

**Examples:**
```asm
; Addition
MOV AL, 5
ADD AL, 3           ; AL = 8

; Subtraction
MOV BL, 10
SUB BL, 4           ; BL = 6

; Multiplication (byte)
MOV AL, 5
MOV BL, 3
MUL BL              ; AX = 15 (AL * BL)

; Division (byte)
MOV AX, 17
MOV BL, 5
DIV BL              ; AL = 3 (quotient), AH = 2 (remainder)
```

### Logical Operations

```asm
AND dest, source    ; Bitwise AND
OR  dest, source    ; Bitwise OR
XOR dest, source    ; Bitwise XOR
NOT dest            ; Bitwise NOT
```

### Comparison and Jump

```asm
CMP op1, op2        ; Compare (op1 - op2, sets flags, doesn't store)

; Conditional Jumps
JE  label           ; Jump if Equal (ZF=1)
JNE label           ; Jump if Not Equal (ZF=0)
JG  label           ; Jump if Greater (signed)
JL  label           ; Jump if Less (signed)
JA  label           ; Jump if Above (unsigned)
JB  label           ; Jump if Below (unsigned)
JMP label           ; Unconditional jump
```

---

## 5. Input/Output Operations {#io-operations}

### DOS Interrupts (INT 21H)

#### Display Single Character
```asm
MOV AH, 02H         ; Function: Display character
MOV DL, 'A'         ; Character to display
INT 21H             ; Call DOS
```

#### Display String
```asm
.DATA
    msg DB 'Hello World!$'   ; String must end with $

.CODE
    LEA DX, msg     ; Load address of string
    MOV AH, 09H     ; Function: Display string
    INT 21H         ; Call DOS
```

#### Input Single Character
```asm
MOV AH, 01H         ; Function: Read character with echo
INT 21H             ; Character returned in AL
```

#### Input Character Without Echo
```asm
MOV AH, 08H         ; Function: Read character without echo
INT 21H             ; Character returned in AL
```

#### Input Buffered String
```asm
.DATA
    maxLen DB 21        ; Maximum length (including length byte)
    actLen DB ?         ; Actual length read
    buffer DB 21 DUP('$')   ; Buffer for input

.CODE
    LEA DX, maxLen      ; Address of buffer
    MOV AH, 0AH         ; Function: Buffered input
    INT 21H
    ; First byte (maxLen) = max chars
    ; Second byte (actLen) = actual chars read
    ; Remaining bytes = actual input
```

---

## 6. Arrays and Memory {#arrays}

### Declaring Arrays

```asm
.DATA
    numbers DB 10, 20, 30, 40, 50    ; Byte array
    len     DB 5                      ; Length
    
    ; At specific address (for your lab)
    ORG 0200H                         ; Set location counter to 0200H
    array   DB 50, 30, 10, 40, 20
```

### Accessing Array Elements

```asm
; Using index register
LEA SI, numbers     ; SI points to start of array
MOV AL, [SI]        ; AL = first element (10)
INC SI              ; Move to next element
MOV AL, [SI]        ; AL = second element (20)

; Using offset
MOV BX, OFFSET numbers
MOV AL, [BX]        ; AL = first element
MOV AL, [BX+1]      ; AL = second element
MOV AL, [BX+2]      ; AL = third element
```

---

## 7. Control Flow (Loops & Conditionals) {#control-flow}

### LOOP Instruction

```asm
; CX register is the loop counter
MOV CX, 5           ; Loop 5 times
myLoop:
    ; Loop body
    LOOP myLoop     ; Decrements CX and jumps if CX != 0
```

### IF-ELSE Structure

```asm
; If AL > 5, do something
CMP AL, 5
JLE else_part       ; Jump if AL <= 5

; IF part
MOV BL, 1
JMP end_if

else_part:
; ELSE part
MOV BL, 0

end_if:
; Continue...
```

### Nested Loops

```asm
MOV CX, 3           ; Outer loop counter
outer_loop:
    PUSH CX         ; Save outer counter
    MOV CX, 4       ; Inner loop counter
    
    inner_loop:
        ; Inner loop body
        LOOP inner_loop
    
    POP CX          ; Restore outer counter
    LOOP outer_loop
```

---

## 8. Complete Problem Solutions {#solutions}

---

### Problem 1: Hello World

**Task**: Write a MASM program to print "Hello World!" to the screen.

**Solution:**

```asm
.MODEL SMALL
.STACK 100H

.DATA
    msg DB 'Hello World!$'    ; $ is string terminator for DOS function 09H

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX
    
    ; Display string
    LEA DX, msg         ; Load address of message
    MOV AH, 09H         ; DOS function: Display string
    INT 21H             ; Call DOS interrupt
    
    ; Exit program
    MOV AH, 4CH         ; DOS function: Terminate program
    INT 21H
MAIN ENDP
END MAIN
```

**Explanation:**
1. `.MODEL SMALL` - Uses small memory model
2. `.DATA` - Declares the message string with $ terminator
3. `MOV AX, @DATA` and `MOV DS, AX` - Initialize data segment register
4. `LEA DX, msg` - Load the address of the message into DX
5. `MOV AH, 09H` and `INT 21H` - DOS interrupt to display string
6. Program terminates with function 4CH

---

### Problem 2: Bubble Sort

**Task**: Implement Bubble Sort algorithm, array stored at address 0200h in data segment.

**Solution:**

```asm
.MODEL SMALL
.STACK 100H

.DATA
    ORG 0200H                   ; Start array at address 0200H
    array DB 50, 30, 10, 40, 20, 60, 15, 35, 25, 45
    
    ORG 0220H                   ; Place len at different address
    len   DB 10                 ; Length of array

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX
    
    ; Bubble Sort Algorithm
    ; Outer loop: i = 0 to len-2
    MOV CH, 0                   ; i = 0
    MOV CL, len
    DEC CL                      ; CL = len - 1
    
outer_loop:
    CMP CH, CL                  ; if i >= len-1, done
    JAE sort_done
    
    ; Inner loop: j = 0 to len-i-2
    MOV BH, 0                   ; j = 0
    MOV BL, len
    SUB BL, CH                  ; BL = len - i
    DEC BL                      ; BL = len - i - 1
    
inner_loop:
    CMP BH, BL                  ; if j >= len-i-1, done with inner loop
    JAE inner_done
    
    ; Compare array[j] with array[j+1]
    MOV SI, 0200H               ; Base address of array
    MOV AL, BH                  ; AL = j
    MOV AH, 0
    ADD SI, AX                  ; SI points to array[j]
    
    MOV AL, [SI]                ; AL = array[j]
    MOV DL, [SI+1]              ; DL = array[j+1]
    
    CMP AL, DL                  ; Compare array[j] with array[j+1]
    JBE no_swap                 ; if array[j] <= array[j+1], no swap
    
    ; Swap array[j] and array[j+1]
    MOV [SI], DL                ; array[j] = array[j+1]
    MOV [SI+1], AL              ; array[j+1] = old array[j]
    
no_swap:
    INC BH                      ; j++
    JMP inner_loop
    
inner_done:
    INC CH                      ; i++
    JMP outer_loop

sort_done:
    ; Print sorted array
    MOV CX, 0                   ; Counter for printing
    MOV CL, len
    MOV SI, 0200H               ; Point to start of array
    
print_loop:
    MOV AL, [SI]                ; Get current element
    
    ; Convert to ASCII and print
    CALL print_number
    
    ; Print space
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    
    INC SI                      ; Move to next element
    LOOP print_loop
    
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Procedure to print a number (0-255)
print_number PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BL, AL                  ; Save number in BL
    MOV AH, 0
    MOV CX, 0                   ; Digit counter
    
    ; Handle zero specially
    CMP BL, 0
    JNE convert_loop
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    JMP print_done
    
convert_loop:
    CMP BL, 0
    JE print_digits
    
    MOV AL, BL
    MOV AH, 0
    MOV BH, 10
    DIV BH                      ; AL = quotient, AH = remainder
    
    PUSH AX                     ; Save remainder (digit)
    INC CX                      ; Count digits
    MOV BL, AL                  ; Continue with quotient
    JMP convert_loop
    
print_digits:
    POP AX                      ; Get digit
    MOV DL, AH                  ; Remainder is the digit
    ADD DL, '0'                 ; Convert to ASCII
    MOV AH, 02H
    INT 21H
    LOOP print_digits
    
print_done:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
print_number ENDP

END MAIN
```

**Explanation:**
1. **ORG 0200H** - Sets the location counter to 0200H, so array starts at this address
2. **Bubble Sort Logic**:
   - Outer loop (i): Goes from 0 to len-2
   - Inner loop (j): Goes from 0 to len-i-2
   - Compares adjacent elements and swaps if needed
3. **Array Access**: Uses SI register with calculated offset
4. **Printing**: Custom procedure converts numbers to ASCII and displays them

---

### Problem 3: Digit Frequency Counter

**Task**: Count frequency of each digit (0-9) in input string, print in ascending order.

**Solution:**

```asm
.MODEL SMALL
.STACK 100H

.DATA
    prompt    DB 'Enter digits (max 20): $'
    newline   DB 0DH, 0AH, '$'
    
    ; Buffered input structure
    maxLen    DB 21             ; Maximum 20 chars + length byte
    actLen    DB ?              ; Actual length
    buffer    DB 21 DUP('$')    ; Input buffer
    
    ; Frequency array (10 elements for digits 0-9)
    freq      DB 10 DUP(0)

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX
    
    ; Display prompt
    LEA DX, prompt
    MOV AH, 09H
    INT 21H
    
    ; Read input string (buffered)
    LEA DX, maxLen
    MOV AH, 0AH                 ; Buffered input
    INT 21H
    
    ; Print newline
    LEA DX, newline
    MOV AH, 09H
    INT 21H
    
    ; Process input: count digit frequencies
    MOV CL, actLen              ; Get actual length
    MOV CH, 0                   ; CX = length
    
    CMP CX, 0                   ; Check if empty
    JE print_freq               ; If empty, skip to printing
    
    LEA SI, buffer              ; Point to start of input
    
count_loop:
    MOV AL, [SI]                ; Get character
    
    ; Check if it's a digit (ASCII 48-57)
    CMP AL, '0'
    JB skip_char                ; Below '0'
    CMP AL, '9'
    JA skip_char                ; Above '9'
    
    ; It's a digit, increment corresponding frequency
    SUB AL, '0'                 ; Convert ASCII to numeric (0-9)
    MOV AH, 0
    MOV BX, AX                  ; BX = digit value
    LEA DI, freq
    ADD DI, BX                  ; DI points to freq[digit]
    INC BYTE PTR [DI]           ; Increment frequency
    
skip_char:
    INC SI                      ; Next character
    LOOP count_loop
    
print_freq:
    ; Print frequencies in format: "digit count "
    MOV CX, 10                  ; 10 digits (0-9)
    MOV BX, 0                   ; Current digit
    
print_loop:
    ; Print digit
    MOV DL, BL
    ADD DL, '0'                 ; Convert to ASCII
    MOV AH, 02H
    INT 21H
    
    ; Print space
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    
    ; Print frequency
    LEA SI, freq
    ADD SI, BX                  ; SI points to freq[digit]
    MOV AL, [SI]                ; Get frequency
    CALL print_number
    
    ; Print space
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    
    INC BX                      ; Next digit
    LOOP print_loop
    
    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Procedure to print a number (0-255)
print_number PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BL, AL                  ; Save number
    MOV CX, 0                   ; Digit counter
    
    ; Handle zero
    CMP BL, 0
    JNE pn_convert
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    JMP pn_done
    
pn_convert:
    CMP BL, 0
    JE pn_print
    
    MOV AL, BL
    MOV AH, 0
    MOV BH, 10
    DIV BH
    
    PUSH AX
    INC CX
    MOV BL, AL
    JMP pn_convert
    
pn_print:
    POP AX
    MOV DL, AH
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP pn_print
    
pn_done:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
print_number ENDP

END MAIN
```

**Key Points:**
- Uses **buffered input (INT 21H, AH=0AH)** as required
- **freq array** stores counts for digits 0-9
- Converts ASCII digits to numeric values by subtracting '0' (48)
- Prints frequencies in ascending order (0 to 9)

---

### Problem 4: Running Mean (Streaming Input)

**Task**: Continuously accept single-digit inputs, update and print running mean after each digit, exit on 'X'.

**Solution:**

```asm
.MODEL SMALL
.STACK 100H

.DATA
    sum    DW 0         ; Cumulative sum (word for larger values)
    count  DW 0         ; Number of digits entered
    mean   DW 0         ; Current mean

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX
    
input_loop:
    ; Read single character (with echo)
    MOV AH, 01H
    INT 21H
    
    ; Check for termination character 'X' or 'x'
    CMP AL, 'X'
    JE exit_program
    CMP AL, 'x'
    JE exit_program
    
    ; Check if it's a digit
    CMP AL, '0'
    JB input_loop       ; Below '0', ignore
    CMP AL, '9'
    JA input_loop       ; Above '9', ignore
    
    ; Valid digit: convert to numeric value
    SUB AL, '0'         ; Convert ASCII to number
    MOV AH, 0           ; AX = digit value
    
    ; Update sum
    ADD sum, AX         ; sum = sum + digit
    
    ; Update count
    INC count           ; count++
    
    ; Calculate mean = sum / count
    MOV AX, sum
    MOV BX, count
    MOV DX, 0           ; Clear DX for division
    DIV BX              ; AX = sum / count (integer division)
    MOV mean, AX        ; Store mean
    
    ; Print newline
    MOV AH, 02H
    MOV DL, 0DH         ; Carriage return
    INT 21H
    MOV DL, 0AH         ; Line feed
    INT 21H
    
    ; Print only first digit of mean
    MOV AX, mean
    MOV BL, 10
    DIV BL              ; AL = tens digit, AH = ones digit
    
    ; Print first digit (ones if mean < 10, tens if mean >= 10)
    CMP AL, 0
    JE print_ones       ; If tens digit is 0, print ones digit
    
    ; Print tens digit (first digit when mean >= 10)
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    JMP after_print
    
print_ones:
    ; Print ones digit (first digit when mean < 10)
    MOV DL, mean
    CMP DL, 10          ; Check if we need to extract ones digit
    JB simple_print
    MOV AL, mean
    MOV AH, 0
    MOV BL, 10
    DIV BL              ; AH = ones digit
    MOV DL, AH
    
simple_print:
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    
after_print:
    ; Print newline for next input
    MOV AH, 02H
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    
    JMP input_loop      ; Continue reading input
    
exit_program:
    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
```

**Explanation:**
1. **Character-by-character input** using INT 21H, AH=01H (with echo)
2. **Maintains cumulative sum and count** in memory
3. **Integer division** for mean calculation (sum / count)
4. **Prints only first digit** of the mean as required
5. **Waits after each mean display** before accepting next input (automatic due to INT 21H, 01H)
6. **Exits when 'X' is encountered**

**Sample Run:**
```
2
2
3
2
4
3
X
```

---

## Key Concepts Summary

### 1. DOS Interrupts (INT 21H)
- **AH = 01H**: Read character with echo
- **AH = 02H**: Display character (DL = char)
- **AH = 09H**: Display string (DX = address, $ terminated)
- **AH = 0AH**: Buffered input
- **AH = 4CH**: Terminate program

### 2. Register Usage Patterns
- **AL/AX**: Arithmetic operations, I/O
- **BX**: Base for array indexing
- **CX**: Loop counter
- **DX**: I/O operations
- **SI/DI**: String and array operations

### 3. Common Pitfalls
- Forgetting to initialize DS register
- Not preserving registers in procedures
- Wrong memory model for program size
- Forgetting $ terminator for strings
- Direct memory-to-memory moves (not allowed, use register)

### 4. Best Practices
- Comment your code extensively
- Use meaningful labels
- Save/restore registers in procedures
- Initialize all variables
- Check array bounds
- Handle edge cases (empty input, zero values)

---

## Additional Resources

### Assembling and Linking MASM Programs

```bash
# Assemble
MASM filename.asm;

# Link
LINK filename.obj;

# Run
filename.exe
```

### Using DOSBox for MASM
1. Install DOSBox
2. Mount folder containing MASM
3. Assemble and run programs in DOSBox environment

### Debugging Tips
- Use DEBUG.COM to step through code
- Print intermediate values to verify logic
- Test with simple inputs first
- Check register values at key points

---

## Practice Problems

1. **Sum of Array**: Calculate sum of array elements
2. **Find Maximum**: Find largest element in array
3. **Palindrome Check**: Check if input string is palindrome
4. **Prime Number**: Check if input number is prime
5. **String Reverse**: Reverse a string
6. **Binary to Decimal**: Convert binary input to decimal
7. **Factorial**: Calculate factorial of a number

---

## Conclusion

This tutorial covered:
- MASM program structure and syntax
- Registers, data types, and memory models
- Instructions for arithmetic, logic, and control flow
- Input/output using DOS interrupts
- Array manipulation and algorithms
- Complete solutions to your lab problems

Practice these concepts by:
1. Typing out the example programs
2. Modifying them to explore variations
3. Solving the practice problems
4. Writing your own programs from scratch

Good luck with your MUP course labs!
