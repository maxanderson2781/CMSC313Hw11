; translate2Ascii.asm
; Compile with: nasm -f elf translate2Ascii.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 translate2Ascii.o -o translate2Ascii
; Run with: ./translate2Ascii

; Author: Max Anderson, Date: 5/15/2025, Class: 8:30 M-W
 
SECTION .data
    inputBuf     db      0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    inputLen     equ     $ - inputBuf
    space        db      ' '
    newline      db      0xA

SECTION .bss
    outputBuf    resb    80          ; Uninitialized buffer
 
SECTION .text
    global  _start
 
_start:
    
    mov esi, inputBuf       ; points to the start of inputBuf
    mov edi, outputBuf      ; points to the start of outputBuf
    mov ecx, 0           ; loop counter (0 to inputLen - 1)

start_loop:
    cmp ecx, inputLen       
    je end_loop ; if equal exit loop

    push ecx         ; Save loop counter
    call translate_byte   ; Call subroutine
    pop ecx         ; Restore loop counter

    ;two translated ASCII bytes are returned in EAX (upper byte in AH, lower in AL)
    ; Save AH and AL before modifying AL later
    mov bl, ah              ; Save translated char 1
    mov bh, al              ; Save translated char 2
    ; Store the first translated byte in outputBuf
    
    ; Store translated characters
    mov [edi], bl
    inc edi
    mov [edi], bh
    inc edi

    cmp ecx, inputLen - 1   
    je continue           ; If last byte dont add space

    mov al, [space]         ; Load space character
    mov [edi], al           ; Store space in outputBuf
    inc edi

continue:
    inc esi                 ; Increment pointer to next input byte
    inc ecx                 ; Increment loop counter
    jmp start_loop      ; Jump back to the start of the loop




end_loop:
    mov al, [newline]
    mov [edi], al
    inc edi ; Increment EDI to point after the newline

    ; Calculate the new length of the output string
    mov edx, edi            
    sub edx, outputBuf      ; Subtract the start address of outputBuf to get the length

    ; Print the outputBuf to the screen (sys_write)
    mov eax, 4              ; sys_write 
    mov ebx, 1              ; stdout
    mov ecx, outputBuf      
                            
    int     80h                ; Call kernel

    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h            ; Call kernel

translate_byte:
    ; Input: byte at [ESI]
    ; Output:
    ;   AH = (original % 95) + 32
    ;   AL = (AH + 17) % 95 + 32

    ; Get first character in range 32–126
    movzx eax, byte [esi]     ; Zero extend input byte
    mov ebx, 95
    xor edx, edx
    div ebx                   ; EAX / 95  (remainder in EDX)
    add dl, 32            ; Ensure a printable range
    mov ch, dl                ; Save first char in CH temporarily

    ; Get second character (AH + 17) % 95 + 32
    movzx eax, ch             ; Zero extend from CH into EAX
    add eax, 17               ; Adds 17 to the character because thats what was in the example
    xor edx, edx
    div ebx
    add dl, 32
    mov al, dl
    mov ah, ch              ; moves the data into the right places so we can access it later

    ret
