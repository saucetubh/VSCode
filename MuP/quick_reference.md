# MASM Quick Reference Guide

## Essential DOS Interrupts (INT 21H)

| Function | AH Value | Description | Input | Output |
|----------|----------|-------------|-------|--------|
| Read character with echo | 01H | Read single character | - | AL = character |
| Display character | 02H | Display single character | DL = character | - |
| Display string | 09H | Display $ terminated string | DX = address | - |
| Buffered input | 0AH | Read string to buffer | DX = buffer address | Buffer filled |
| Terminate program | 4CH | Exit to DOS | - | - |

## Register Summary

### General Purpose (16-bit)
- **AX** (AH + AL): Accumulator - arithmetic, I/O
- **BX** (BH + BL): Base - addressing, indexing
- **CX** (CH + CL): Counter - loop control
- **DX** (DH + DL): Data - I/O, multiplication/division

### Segment Registers
- **CS**: Code Segment
- **DS**: Data Segment  
- **SS**: Stack Segment
- **ES**: Extra Segment

### Index and Pointer
- **SI**: Source Index
- **DI**: Destination Index
- **BP**: Base Pointer
- **SP**: Stack Pointer

## Common Instructions

### Data Movement
```asm
MOV dest, source    ; Move data
LEA reg, memory     ; Load effective address
```

### Arithmetic
```asm
ADD dest, source    ; Addition
SUB dest, source    ; Subtraction
INC dest            ; Increment by 1
DEC dest            ; Decrement by 1
MUL source          ; Unsigned multiplication (AL or AX)
DIV source          ; Unsigned division (AX by source)
```

### Logic
```asm
AND dest, source    ; Bitwise AND
OR  dest, source    ; Bitwise OR
XOR dest, source    ; Bitwise XOR
NOT dest            ; Bitwise NOT
```

### Comparison and Jumps
```asm
CMP op1, op2        ; Compare (sets flags)
JE  label           ; Jump if equal (ZF=1)
JNE label           ; Jump if not equal (ZF=0)
JG  label           ; Jump if greater (signed)
JL  label           ; Jump if less (signed)
JA  label           ; Jump if above (unsigned)
JB  label           ; Jump if below (unsigned)
JMP label           ; Unconditional jump
LOOP label          ; Decrement CX and jump if CX!=0
```

### Stack Operations
```asm
PUSH source         ; Push onto stack
POP  dest           ; Pop from stack
```

## Data Types

```asm
DB  value           ; Define Byte (8 bits)
DW  value           ; Define Word (16 bits)
DD  value           ; Define Doubleword (32 bits)
DUP(value)          ; Duplicate (array initialization)
```

## Program Structure Template

```asm
.MODEL SMALL
.STACK 100H

.DATA
    ; Variables here

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Your code here
    
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
```

## ASCII Conversion

- **ASCII to Numeric**: `SUB AL, '0'` or `SUB AL, 48`
- **Numeric to ASCII**: `ADD AL, '0'` or `ADD AL, 48`

## Character Codes

- **'0' to '9'**: ASCII 48-57 (30H-39H)
- **'A' to 'Z'**: ASCII 65-90 (41H-5AH)
- **'a' to 'z'**: ASCII 97-122 (61H-7AH)
- **Space**: ASCII 32 (20H)
- **Carriage Return**: 13 (0DH)
- **Line Feed**: 10 (0AH)

## Common Patterns

### Loop Through Array
```asm
LEA SI, array
MOV CX, length
loop_label:
    MOV AL, [SI]
    ; Process element
    INC SI
    LOOP loop_label
```

### Print Number (0-255)
```asm
; Convert and print using division by 10
; Extract digits, push to stack, then print
```

### String Termination
```asm
msg DB 'Hello$'     ; $ for DOS function 09H
```

### Buffered Input Structure
```asm
maxLen DB 21        ; Max characters + 1
actLen DB ?         ; Actual length returned
buffer DB 21 DUP(0) ; Input buffer
```

## Addressing Modes

```asm
MOV AL, 5           ; Immediate
MOV AL, BL          ; Register
MOV AL, [SI]        ; Register indirect
MOV AL, array       ; Direct
MOV AL, [SI+5]      ; Indexed
MOV AL, [BX+SI]     ; Based indexed
```

## Common Mistakes to Avoid

1. Forgetting to initialize DS register
2. Memory-to-memory moves (use register intermediate)
3. Forgetting $ terminator for strings (function 09H)
4. Not preserving registers in procedures
5. Wrong loop counter (CX)
6. Division without clearing DX
7. Array index out of bounds

## Flags Affected by Operations

- **CF**: Carry Flag (overflow in unsigned)
- **ZF**: Zero Flag (result is zero)
- **SF**: Sign Flag (negative result)
- **OF**: Overflow Flag (overflow in signed)
- **PF**: Parity Flag (even parity)

## Procedure Template

```asm
proc_name PROC
    PUSH AX         ; Save registers
    PUSH BX
    
    ; Procedure body
    
    POP BX          ; Restore registers (reverse order)
    POP AX
    RET
proc_name ENDP
```

## Tips for Success

1. **Comment your code** - Explain what each section does
2. **Use meaningful labels** - Makes code readable
3. **Test incrementally** - Start simple, add features
4. **Check edge cases** - Empty input, zero values, max values
5. **Debug systematically** - Print intermediate values
6. **Preserve registers** - Save/restore in procedures
7. **Initialize variables** - Don't assume zero values
8. **Validate input** - Check ranges and formats
