bits 16
org 0x7c00 ; init memory of the bootloader

; Here below, I define a lot of useful constants to make
; easier the work

; Video Interrupt and his functions
videoINT equ 10h
setCursorPos equ 02h
writeChar equ 0ah

; System Services Interrupt and his functions
systemServicesINT equ 15h
waitServ equ 86h

; Keyboard Interrupt and his functions
keybINT equ 16h
keybRead equ 00h
keybStatus equ 01h

; Timer clock Interrupt and his functions
; I'll use this for 'randomize' food position each time it gets ate
timerINT equ 1ah
readTimeCounter equ 00h


; ID codes of Keyboard Arros (CODES, NOT ASCII!!!)
up equ 48h
down equ 50h
left equ 4bh
right equ 4dh

call clearScreen

call showPointsFirstTime

call handleFood

init:

    ; We need to slow down the program to be interactive
    mov AH, waitServ
    mov CX, 1 ; seconds
    mov DX, 0 ; microseconds
    int systemServicesINT

    call detectKeyb

    ; Code to print erase the head of the snake (REMEMBER ITS MOVING)
    mov AH, writeChar
    mov BH, 0
    mov CX, 1
    mov AL, ' '
    int videoINT

    ; We check if the position of the snake is eq to the food pos
    mov AL, [posFood]
    cmp [posRow], AL
    jne normalExecution

    cmp [posColumn], AL
    jne normalExecution

    call addPoint
    call handleFood
    call showPoints
    call checkWin

    normalExecution:
        mov AH, setCursorPos
        mov DH, [posRow] ; Row 
        mov DL, [posColumn] ; Column
        mov BH, 0
        int videoINT

        ; Code to print the head of the snake
        mov AH, writeChar
        mov BH, 0
        mov CX, 1
        mov AL, 'o'
        int videoINT

        ; Here i start to check which movement was done
        ; Is left?

        cmp byte [scanCode], left
        jne checkRight
        dec byte [posColumn]
        jmp init
    
        ; Else Compare all of the others

        checkRight:
            cmp byte [scanCode], right
            jne checkUp
            inc byte [posColumn]
            jmp init

        checkUp:
            cmp byte [scanCode], up
            jne checkDown
            dec byte [posRow]
            jmp init

        checkDown:
            cmp byte [scanCode], down
            jne init
            inc byte [posRow]
            jmp init

        jmp init


detectKeyb:
    mov AH, keybStatus
    int keybINT
    jz endDetectKeyb

    mov AH, keybRead
    int keybINT

    mov [scanCode], AH

endDetectKeyb:
    ret

handleFood:
    ; We read the system tymer to have a 'random' value for our food position (column)
    mov AH, readTimeCounter
    int timerINT
    mov AL, 0fh
    and AL, DL
    mov byte [posFood], AL
    add byte [posFood], 3 ; To ensure the food is placing in a right site

    mov AH, setCursorPos
    mov DH, [posFood]
    mov DL, [posFood]
    mov BH, 0
    int videoINT

    ; Code to print food
    mov AH, writeChar
    mov BH, 0
    mov CX, 1
    mov AL, '&'
    int videoINT

    ; This is to not overwrite the printed food next in the main
    ; loop of the program (init)
    mov AH, setCursorPos
    mov DH, 0
    mov DL, 0
    mov BH, 0
    int videoINT

    ret


showPointsFirstTime:
    mov si, 0 ;character counter

    mov AH, setCursorPos
    mov DH, 1
    mov DL, 71
    mov BH, 0
    int videoINT

    call printPoints
    call showPoints
    ret

showPoints:
    mov AH, setCursorPos
    mov DH, 1
    mov DL, 79
    mov BH, 0
    int videoINT

    mov AH, writeChar
    mov AL, [points]
    add AL, 30h
    mov BH, 0
    mov CX, 1
    int videoINT

    ret

addPoint:
    inc byte [points]
    ret

printPoints:
    mov ah, 0eh
    mov al, [stringPoints + si]
    int 10h

    add si, 1
    cmp byte [stringPoints + si], 0
    jne printPoints

    ret

stringPoints:
    db "Points: ", 0


clearScreen:
    mov AH, setCursorPos
    mov DL, 0
    mov DH, 0
    int videoINT

    mov AH, writeChar
    mov AL, ' '
    mov CX, 1000
    int videoINT

    ret

checkWin:
    mov AH, 10
    cmp AH, [points]
    jz setWin
    
    ret
setWin:
    call clearScreen

    mov si, 0 ;character counter
    mov AH, setCursorPos
    mov DH, 13
    mov DL, 35
    mov BH, 0
    int videoINT

    call printWin

printWin:
    mov ah, 0eh
    mov al, [stringWin + si]
    int 10h

    add si, 1
    cmp byte [stringWin + si], 0
    jne printWin

    jmp $ ; END OF THE GAME

stringWin:
    db "You Won!", 0


posRow:
    db 10
posColumn:
    db 5
scanCode:
    db left
posFood:
    db 10
points:
    db 0


times 510 - ($ - $$) db 0
dw 0xAA55