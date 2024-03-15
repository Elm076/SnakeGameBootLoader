# Snake Game BootLoader

## First Loook
This game is a BootLoader working on x86 assembly.
It is a simpler version of the retro snake game that has to eat all the food till it fills all of the screen or eat itself.
In this case, the game will end when you reach 10 pieces of food and the snake will not grow each time it eats.

### Code of the game
#### Charge of the program in the bootloader memory direction
We will set the init of the program where the BIOS will search the Bootloader to charge the game into the system
`bits 16
org 0x7c00 ; init memory of the bootloader`


#### Global declarations and constants
We will set all the Interruptions functions and constants to make easier the code
_Check it from the line 12 to 31_

#### Begining of the game
At the start of the game we clear the screen and prepare it to set the visual interface
_Check it from the line 33 to 37_

#### Main squeleton of the game
The lable _init_ will be squeleton of the game consisting of a loop that will repeat till we reach the 10 food stroke and win the game.
_Check it from the line 39 to 111_
Inside of the loop we have to differs some logic parts:
  - `; We need to slow down the program to be interactive
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
    int videoINT`
