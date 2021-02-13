***************************************************************************************************
*
* Title:        LED Light ON/OFF and Switch ON/OFF
*
* Objective:    CMPEN472 Homework 3
*
* Revision:     V1.0 for CodeWarrior 5.9 Debugger Simulation
*
* Date:         Feb. 9, 2021
*
* Programmer:   Kieran Sweeney
*
* Company:      The Pennsylvania State University
*               Department of Computer Science and Engineering
*
* Program:      Tests different ways of loading immediates into regA, then tests the ability to
*               move values to and from memory.
*
* Notes:
*
*
* Algorithm:    Run the loading and memory ops, then loop back and repeat
*
* Register Use: A: The reg we tinker with.
*
* Memory Use:   RAM Locations from $3000 for the data
*               RAM locations from $3100 for the program
*
* Input:        None
*
* Output:       None
*
* Observations: It works!
*               -> We can shuffle values to and from memory !
*               -> Demonstrated different addressing modes
*                   -> LDAA #20 loads regA with 0d20 (decimal 20)
*                   -> LDAA #$20 loads regA with 0x20 (hex 20, decimal 32)
*                   -> LDAA $20 pulls whatever value is stored at memory location 20 (technically 0x20)
*

***************************************************************************************************
* Parameter Declaration Section
*
* Export Symbols
            XDEF        pstart      ; Export 'pstart' symbol
            ABSENTRY    pstart      ; For assembly entry point

* Symbols & Macros
PORTA       EQU         $0000       ; i/o port A addresses
DDRA        EQU         $0002
PORTB       EQU         $0001       ; i/o port B addresses
DDRB        EQU         $0003

***************************************************************************************************
* Data Section: Addresses used [ $3000 to $30FF ] in RAM memory
*
            ORG         $3000       ; Reserved RAM memory starting address

numbah      DC.W        $002E       ; something to start with

ONN         DC.B        $0001       ; need a place to store ONN. Can initialize to 0.
OFF         DC.B        $0010       ; need a place to store OFF. Can initialize to 0.



* the remaining data memory space up to the start of program memory is for the stack.
* Make sure the visualizer is set to cpu cycle refresh mode, Automatic doesn't work!
*
***************************************************************************************************
* Program Section: Addresses used [ $3100 to $3FFF ] in RAM memory
*
            ORG         $3100       ; Program start address, in RAM
pstart      LDS         #$3100      ; initialize the stack pointer

mainLoop

            LDAA        #23    ;    ; loads decimal 23
            NOP
            LDAA        #$23        ; loads hex 0x23 = 35
            NOP
            LDAA        #%01        ; loads binary immediate
            NOP
            LDAA        $3001       ; loads value (0d46) stored at memory location 3001 (really 0x3001).
            NOP
            LDAA        numbah      ; hmm why does this load 0d0 rather than 0d46? Because numbah is 2-bytes (DC.W)!
                                    ; regA is only 1 byte wide! $3001 works because it takes the last 8 bits of numbah!
                                    ; the reason we get 0d0 for numbah is that the first byte of a 2-byte 0d46 is all 0s!
            NOP                     ;
            LDAA        $3001       ; load the "important" part of numbah so that we can continue the demo
            NOP                     ;
            DECA                    ; decrease value in regA from $3001 by 1 (46-1 = 0d45)
            NOP
            STAA        ONN         ; store at memory location of ONN
            NOP
            LDAA        ONN         ; load regA with value (0d45) stored at memory location of ONN
            DECA                    ; decrease value from ONN by 1 (45-1 = 0d44)
            NOP
            STAA        OFF         ; store regA (0d44) at memory location of OFF
            LDAA        ONN         ; load regA with value (0d45) stored at memory location of ONN
            STAA        OFF         ; store at memory location of OFF (now 0d45)
            NOP                     ; go see if it works! Both OFF and ONN should end with a value of 0d45

            BRA         mainLoop    ; return to main loop to run through the dimup-dimdown cycle again



            end                         ; Last line of file!
