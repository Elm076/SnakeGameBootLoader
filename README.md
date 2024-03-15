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
_Check it from the line 12 to 31 and from 250 to 263_

#### Sign the bootloader
As a bootloader, we need to sign it with:
`times 510 - ($ - $$) db 0
dw 0xAA55`

#### Begining of the game
At the start of the game we clear the screen and prepare it to set the visual interface
_Check it from the line 33 to 37_

#### Main squeleton of the game
The lable _init_ will be squeleton of the game consisting of a loop that will repeat till we reach the 10 food stroke and win the game.
_Check it from the line 39 to 111_
 
**Some important functions**
- **Code from line 57 to 67**: We check if we reached a fruit on the screen comparing the position of the snake and the fruit and determines if we need to add points and regenerate the fruit or simply continue with the normal execution
- **Check'X'**: Where X is left, right, up or down. It checks if we did a movement and starts again the main loop
- **detectKeyb**: Detect if some key was pressed in the keyb. It will help the Check'X' functions
- **handleFood**: **Important!** It is some key function for this program. It handles all of the food department. We can differ 2 different part of this function:
  - **Take "random" numbers to reinitialice the fruit**: The first part of the function (_Check from line 129 to _134) uses a internal time counter to try to get "random numbers" and reinitialice the fruit to a new position when it gets eaten. Take in note that im only getting one sample from the timer and im using the small part to get in fit into the qemu default window. So the row and column position will be the same for the fruit (it will be in a diagonal).
  - **Print the fruit in the screen**: After getting the new fruit position, it will be printed in the screen using the video interruption. _Check from line 136 to 157_
- **CheckWin**: After getting a new fruit, it will check if we won (reached 10 fruits) or not.
- **SetWin**: If we won, we clear the screen and print a win message finishing the game.

## Usage
You need to have installed in your computer NASM and QEMU to run the game.
1. If you don't have NASM installed use in the Ubuntu Terminal:
  - `sudo apt install nasm`
2. If you don't have QEMU installed use in the Ubuntu Terminal:
  - `sudo apt install qemu`
3. To run the game just give exectue permissions to the shell bash script fitted in the repo:
  - `sudo chmod +x ./run_game.sh`
4. And next run it:
  - `./run_game.sh`
5. Once in the game, the controls are:
  - **Up arrow** for going up
  - **Down arrow** for going down
  - **Left arrow** for going left
  - **Right arrow** for going right

## Aspects to take into account
The game is still under develop so there are some minor bugs that might happen to you when playing:
- Sometimes, when u eat a piece of food, as the random generator isn't 100% fittable in this program, the food won't respawn and you need to restart the game and go for another match
- The limits of the screen are handled by the qemu's default window, so if you reach the top or bottom edge you won't see anymore the snake but it's actually still playing. Just if you go to high, set the snake's direction down and eventually the snake will be again inside the play area and vice versa if you get too low.

## That's all!
Enjoy it 😁
