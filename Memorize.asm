;*****************************************************************************
;  Author: Chris Bailey
;  Due: 05/14/2025
;  Revision: 1.0
;  Final Project
;  Name: Memorize
;
; Description:
;  This is a console game that prompts a user to start game, and it will display
;   a sequence of numbers that the user must enter in the correct order to win.
; 
;
; Register Usage:
; R0 - Used for trap's
; R1 - Used as temp value
; R2 - Used to iterate through
; R3 - Store and load data
; R4 - Game state variable
; R5 - Temp register
; R6 - Reserved for stack use
; R7 - Return addresses
;****************************************************************************
    .ORIG x3000
    
    LD R6, STACK        ; set stack pointer
    
    JSR DISPLAY_MENU    ; Display start menu
    
    JSR NEWLINE
    
    JSR INSTRUCTIONS    ; Dsplay Instructions
    
    JSR CLEAR_SCREEN    ; Clear screen
    
    AND R4, R4, #0
    
    JSR BOARD_LOOP      ; Display all nums

    JSR NEWLINE
    
    JSR GUESS_ENTER     ; Usr enters their guess
    
    HALT

;***********************CONSTS & STRINGS*************************
STACK          .FILL xFE00
    

;************************SUBROUTINES*************************

;**********************DISPLAY_MENU*********************
; This subroutine displays the welcome menu for the user
;
; NOTE: PTR's used becasue I was getting errors for the 
; ascii art bring too long where LEA only can see 255 
; lines away. (Had to look this up)
;
;R0 - Used for trap's
;R1 - Used to check for if enter was pressed
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************
DISPLAY_MENU
    ; Save R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    LD R0, PTR_MENU_LINE1
    PUTS
    LD R0, PTR_MENU_LINE2
    PUTS
    LD R0, PTR_MENU_LINE3
    PUTS
    LD R0, PTR_MENU_LINE4
    PUTS
    LD R0, PTR_MENU_LINE5
    PUTS
    LD R0, PTR_MENU_LINE6
    PUTS
    LD R0, PTR_NEXT
    PUTS

    JSR PRESS_ENTER
    
    JSR NEWLINE
    
    ; Restore R7 from stack (POP)
    LDR R7, R6, #0
    ADD R6, R6, #1
    
    RET

PTR_MENU_LINE1 .FILL MENU_LINE1
PTR_MENU_LINE2 .FILL MENU_LINE2
PTR_MENU_LINE3 .FILL MENU_LINE3
PTR_MENU_LINE4 .FILL MENU_LINE4
PTR_MENU_LINE5 .FILL MENU_LINE5
PTR_MENU_LINE6 .FILL MENU_LINE6
PTR_NEXT       .FILL NEXT
MENU_LINE1 .STRINGZ " __  __ ______ __  __  ____  _____ _____ ______  ______ \n"
MENU_LINE2 .STRINGZ "|  \/  |  ____|  \/  |/ __ \|  __ \_   _|____  ||  ____|\n"
MENU_LINE3 .STRINGZ "| \  / | |__  | \  / | |  | | |__) || |     / / | |__   \n"
MENU_LINE4 .STRINGZ "| |\/| |  __| | |\/| | |  | |  _  / | |    / /  |  __|  \n"
MENU_LINE5 .STRINGZ "| |  | | |____| |  | | |__| | | \ \_| |_  / /___| |____ \n"
MENU_LINE6 .STRINGZ "|_|  |_|______|_|  |_|\____/|_|  \_\_____|______|______|\n"
NEXT       .STRINGZ "Press Enter for Instructions..."


;**********************INSTRUCTIONS*********************
; This subroutine displays the game instructions
;
;R0 - Used for trap's
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************
INSTRUCTIONS
    ; Save R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    LEA R0, INS_LINE1
    PUTS
    
    LEA R0, INS_LINE2
    PUTS
    
    LEA R0, INS_LINE3
    PUTS
    
    LEA R0, INS_LINE4
    PUTS
    
    JSR NEWLINE
    
    JSR BOARD_SHOW_NUMS ; Show starting board for directions
    
    LEA R0, START
    PUTS
    
    JSR PRESS_ENTER
    
    ; Restore R7 from stack (POP)
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
INS_LINE1 .STRINGZ "Watch the board closely!\n...\n"
INS_LINE2 .STRINGZ "Guess the correct number string at the end to win the game.\n...\n"
INS_LINE3 .STRINGZ "This will be all availble numbers to guess from.\n...\n"
INS_LINE4 .STRINGZ "Good luck!"
START     .STRINGZ "Press Enter to Start Game..."
    
    
;**********************BOARD_SHOW_NUMS******************
; This subroutine displays the memory board with all the
; number availible that will be used later in the game.
;
;R0 - Used for trap's
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************
BOARD_SHOW_NUMS
    ; Save R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    LEA R0, BOARD_SHOW_NUMS_LINE1
    PUTS
    LEA R0, BOARD_SHOW_NUMS_LINE2
    PUTS
    LEA R0, BOARD_SHOW_NUMS_LINE3
    PUTS
    LEA R0, BOARD_SHOW_NUMS_LINE4
    PUTS
    LEA R0, BOARD_SHOW_NUMS_LINE5
    PUTS
    LEA R0, BOARD_SHOW_NUMS_LINE6
    PUTS
    LEA R0, BOARD_SHOW_NUMS_LINE7
    PUTS
    
    ; Restore R7 from stack (POP)
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
BOARD_SHOW_NUMS_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_SHOW_NUMS_LINE2 .STRINGZ "| 1 | 2 | 3 |\n"
BOARD_SHOW_NUMS_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_SHOW_NUMS_LINE4 .STRINGZ "| 4 | 5 | 6 |\n"
BOARD_SHOW_NUMS_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_SHOW_NUMS_LINE6 .STRINGZ "| 7 | 8 | 9 |\n"
BOARD_SHOW_NUMS_LINE7 .STRINGZ "+---+---+---+\n"


;**********************PRESS_ENTER**************************
; This subroutine displays doesn't procees until enter is
; pressed
;
;R0 - Used for trap's
;R1 - Check for enter ascii
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************
PRESS_ENTER
    ; Save R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0
    ENTER
        GETC
        ADD R1, R0, #-10
        BRnp ENTER
    
    ; Restore R7 from stack (POP)
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
    

;**********************CLEAR_SCREEN**************************
; This subroutine clears the displays
;
;R0 - Used for trap's
;R1 - Loop counter
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************
CLEAR_SCREEN
    ; Save R0, R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R2, R6, #0
    ADD R6, R6, #-1
    STR R0, R6, #0
    
    AND R1, R1, #0  ; Clear R1
    LD R1, NUM_30   ; Load R1 = #30
    
CLEAR_LOOP
    JSR NEWLINE
    ADD R1, R1, #-1
    BRp CLEAR_LOOP
    
    ;Restore R0, R7 from stack (POP)
    LDR R0, R6, #0
    ADD R6, R6, #1
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
NUM_30 .FILL #30


;**********************NEWLINE**************************
; This subroutine displays a newline character
;
;R0 - Used for trap's
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************
NEWLINE
    ; Save R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0

    LEA R0, NEWLINE_CHAR
    PUTS

    ; Restore R7 from stack (POP)
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
NEWLINE_CHAR .STRINGZ "\n"

;**********************GUESS_ENTER**********************
; This subroutine displays lets user enter a guess
;
;R0 - Used for trap's
;R1 - Holds ASCII offset
;R2 - Store position in sequence of nums
;R3 - Holds value of sequence
;R4 - Comparison
;R5 - User input
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************
GUESS_ENTER
    ; Save R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    LEA R0, GUESS_INSTRUCTIONS
    PUTS
    
    LEA R0, GUESS_PROMPT
    PUTS
    
    LD R1, ASCII_NEG
    LEA R2, SEQUENCE
GUESS_LOOP
    LDR R3, R2, #0
    BRz CORRECT
    
    GETC
    OUT
    
    AND R5, R0, #0
    ADD R5, R5, R0
    ADD R5, R5, R1
    
    NOT R4, R3
    ADD R4, R4, #1 
    ADD R4, R4, R5 
    BRnp WRONG 

    ADD R2, R2, #1   ; Move to next num
    BRnzp GUESS_LOOP

CORRECT
    LEA R0, CORRECT_MSG
    PUTS
    BRnzp GUESS_EXIT

WRONG
    LEA R0, WRONG_MSG
    PUTS
    BRnzp GUESS_EXIT

GUESS_EXIT
    
    ; Restore R7 from stack (POP)
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
GUESS_INSTRUCTIONS .STRINGZ "Press Enter When Guess is Done.\n"
GUESS_PROMPT       .STRINGZ "Guess: "
CORRECT_MSG        .STRINGZ "\nCORRECT!!!!"
WRONG_MSG          .STRINGZ "\nWRONG Guess..."
ASCII_NEG          .FILL #-48
SEQUENCE
    .FILL #3
    .FILL #7
    .FILL #1
    .FILL #9
    .FILL #4
    .FILL #6
    .FILL #0     ; Null terminator
         
; SEQUENCE
;     .FILL #7
;     .FILL #9
;     .FILL #3
;     .FILL #6
;     .FILL #8
;     .FILL #1
;     .FILL #0    ; Null terminator
    
; SEQUENCE
;     .FILL #5
;     .FILL #1
;     .FILL #9
;     .FILL #8
;     .FILL #4
;     .FILL #6
;     .FILL #0    ; Null terminator


;**********************DISPLAY_BOARD******************
; This subroutine displays the board
;
;R0 - Used for trap's
;R1 - Used by caller of subroutine
;R2 - Loop counter
;R3 - Address of curr pointer
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************
DISPLAY_BOARD
    ; Save R0, R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R2, R6, #0
    ADD R6, R6, #-1
    STR R0, R6, #0
    
    AND R2, R2, #0
    
DISPLAY_LOOP
    ADD R3, R1, R2
    LDR R0, R3, #0
    PUTS
    ADD R2, R2, #1
    
    ADD R3, R2, #-7  ; Number of lines in display board
    BRnp DISPLAY_LOOP
    
    ; Restore R0, R7 from stack (POP)
    LDR R0, R6, #0
    ADD R6, R6, #1
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
  
;**********************TIMER****************************
; This subroutine is a game timer
;
;R0 - Used for trap's
;R4 - Outer loop
;R5 - Inner loop
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************  
TIMER
    ; Save R0, R4, R5, R7 to stack (PUSH)
    ADD R6, R6, #-1
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R4, R6, #0
    ADD R6, R6, #-1
    STR R5, R6, #0
    ADD R6, R6, #-1
    STR R2, R6, #0
    ADD R6, R6, #-1
    STR R1, R6, #0
    ADD R6, R6, #-1
    STR R0, R6, #0
    
    ;Timer
    LD R4, DELAY
TIME_OUTER
    LD R5, TIME
TIME_INNER
    ADD R5, R5, #-1
    BRzp TIME_INNER
    
    ADD R4, R4, #-1
    BRzp TIME_OUTER
    
    ; Restore R0, R4, R5, R7 from stack (POP)
    LDR R0, R6, #0
    ADD R6, R6, #1
    LDR R1, R6, #0
    ADD R6, R6, #1
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R4, R6, #0
    ADD R6, R6, #1
    LDR R5, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
TIME          .FILL 64000
DELAY         .FILL 20000


;**********************BOARD_LOOP***********************
; This subroutine displays the boards through a loop
;
;R0 - Used for trap's
;R1 - Used as index for table
;R2 - Pointer to sequence
;R6 - Reserved for stack use
;R7 - Return address
;*******************************************************  
BOARD_LOOP
    ; Save R7
    ADD R6, R6, #-1
    STR R7, R6, #0

    LEA R2, SEQUENCE      ; Load address of sequence into R2

BOARD_LOOP_NEXT
    LDR R0, R2, #0        ; Load current number from sequence
    BRz BOARD_END_LOOP    ; If 0, we're done

    ADD R2, R2, #1        ; Move to next entry in sequence

    ADD R0, R0, #-1       ; Convert 1-based index to 0-based

    ; Use R0 to index into BOARD_TABLE
    LEA R1, BOARD_TABLE
    ADD R1, R1, R0        ; R1 = &BOARD_TABLE[n-1]
    LDR R1, R1, #0        ; R1 = pointer to BOARD_n string

    JSR DISPLAY_BOARD     ; Show board
    JSR TIMER             ; Wait
    JSR CLEAR_SCREEN      ; Clear screen

    BRnzp BOARD_LOOP_NEXT ; Loop again

BOARD_END_LOOP
    ; Restore R7
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

BOARD_TABLE
    .FILL BOARD_1_PTRS
    .FILL BOARD_2_PTRS
    .FILL BOARD_3_PTRS
    .FILL BOARD_4_PTRS
    .FILL BOARD_5_PTRS
    .FILL BOARD_6_PTRS
    .FILL BOARD_7_PTRS
    .FILL BOARD_8_PTRS
    .FILL BOARD_9_PTRS
    
BOARD_E_PTRS
    .FILL BOARD_EMPTY_LINE1
    .FILL BOARD_EMPTY_LINE2
    .FILL BOARD_EMPTY_LINE3
    .FILL BOARD_EMPTY_LINE4
    .FILL BOARD_EMPTY_LINE5
    .FILL BOARD_EMPTY_LINE6
    .FILL BOARD_EMPTY_LINE7

BOARD_1_PTRS
    .FILL BOARD_1_LINE1
    .FILL BOARD_1_LINE2
    .FILL BOARD_1_LINE3
    .FILL BOARD_1_LINE4
    .FILL BOARD_1_LINE5
    .FILL BOARD_1_LINE6
    .FILL BOARD_1_LINE7
    
BOARD_2_PTRS
    .FILL BOARD_2_LINE1
    .FILL BOARD_2_LINE2
    .FILL BOARD_2_LINE3
    .FILL BOARD_2_LINE4
    .FILL BOARD_2_LINE5
    .FILL BOARD_2_LINE6
    .FILL BOARD_2_LINE7
    
BOARD_3_PTRS
    .FILL BOARD_3_LINE1
    .FILL BOARD_3_LINE2
    .FILL BOARD_3_LINE3
    .FILL BOARD_3_LINE4
    .FILL BOARD_3_LINE5
    .FILL BOARD_3_LINE6
    .FILL BOARD_3_LINE7
    
BOARD_4_PTRS
    .FILL BOARD_4_LINE1
    .FILL BOARD_4_LINE2
    .FILL BOARD_4_LINE3
    .FILL BOARD_4_LINE4
    .FILL BOARD_4_LINE5
    .FILL BOARD_4_LINE6
    .FILL BOARD_4_LINE7
    
BOARD_5_PTRS
    .FILL BOARD_5_LINE1
    .FILL BOARD_5_LINE2
    .FILL BOARD_5_LINE3
    .FILL BOARD_5_LINE4
    .FILL BOARD_5_LINE5
    .FILL BOARD_5_LINE6
    .FILL BOARD_5_LINE7
    
BOARD_6_PTRS
    .FILL BOARD_6_LINE1
    .FILL BOARD_6_LINE2
    .FILL BOARD_6_LINE3
    .FILL BOARD_6_LINE4
    .FILL BOARD_6_LINE5
    .FILL BOARD_6_LINE6
    .FILL BOARD_6_LINE7
    
BOARD_7_PTRS
    .FILL BOARD_7_LINE1
    .FILL BOARD_7_LINE2
    .FILL BOARD_7_LINE3
    .FILL BOARD_7_LINE4
    .FILL BOARD_7_LINE5
    .FILL BOARD_7_LINE6
    .FILL BOARD_7_LINE7
    
BOARD_8_PTRS
    .FILL BOARD_8_LINE1
    .FILL BOARD_8_LINE2
    .FILL BOARD_8_LINE3
    .FILL BOARD_8_LINE4
    .FILL BOARD_8_LINE5
    .FILL BOARD_8_LINE6
    .FILL BOARD_8_LINE7
    
BOARD_9_PTRS
    .FILL BOARD_9_LINE1
    .FILL BOARD_9_LINE2
    .FILL BOARD_9_LINE3
    .FILL BOARD_9_LINE4
    .FILL BOARD_9_LINE5
    .FILL BOARD_9_LINE6
    .FILL BOARD_9_LINE7

    .END
    
    .ORIG x4000
    
BOARD_EMPTY_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_EMPTY_LINE2 .STRINGZ "|   |   |   |\n"
BOARD_EMPTY_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_EMPTY_LINE4 .STRINGZ "|   |   |   |\n"
BOARD_EMPTY_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_EMPTY_LINE6 .STRINGZ "|   |   |   |\n"
BOARD_EMPTY_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_1_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_1_LINE2 .STRINGZ "| 1 |   |   |\n"
BOARD_1_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_1_LINE4 .STRINGZ "|   |   |   |\n"
BOARD_1_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_1_LINE6 .STRINGZ "|   |   |   |\n"
BOARD_1_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_2_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_2_LINE2 .STRINGZ "|   | 2 |   |\n"
BOARD_2_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_2_LINE4 .STRINGZ "|   |   |   |\n"
BOARD_2_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_2_LINE6 .STRINGZ "|   |   |   |\n"
BOARD_2_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_3_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_3_LINE2 .STRINGZ "|   |   | 3 |\n"
BOARD_3_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_3_LINE4 .STRINGZ "|   |   |   |\n"
BOARD_3_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_3_LINE6 .STRINGZ "|   |   |   |\n"
BOARD_3_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_4_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_4_LINE2 .STRINGZ "|   |   |   |\n"
BOARD_4_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_4_LINE4 .STRINGZ "| 4 |   |   |\n"
BOARD_4_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_4_LINE6 .STRINGZ "|   |   |   |\n"
BOARD_4_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_5_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_5_LINE2 .STRINGZ "|   |   |   |\n"
BOARD_5_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_5_LINE4 .STRINGZ "|   | 5 |   |\n"
BOARD_5_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_5_LINE6 .STRINGZ "|   |   |   |\n"
BOARD_5_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_6_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_6_LINE2 .STRINGZ "|   |   |   |\n"
BOARD_6_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_6_LINE4 .STRINGZ "|   |   | 6 |\n"
BOARD_6_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_6_LINE6 .STRINGZ "|   |   |   |\n"
BOARD_6_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_7_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_7_LINE2 .STRINGZ "|   |   |   |\n"
BOARD_7_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_7_LINE4 .STRINGZ "|   |   |   |\n"
BOARD_7_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_7_LINE6 .STRINGZ "| 7 |   |   |\n"
BOARD_7_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_8_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_8_LINE2 .STRINGZ "|   |   |   |\n"
BOARD_8_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_8_LINE4 .STRINGZ "|   |   |   |\n"
BOARD_8_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_8_LINE6 .STRINGZ "|   | 8 |   |\n"
BOARD_8_LINE7 .STRINGZ "+---+---+---+\n"

BOARD_9_LINE1 .STRINGZ "+---+---+---+\n"
BOARD_9_LINE2 .STRINGZ "|   |   |   |\n"
BOARD_9_LINE3 .STRINGZ "+---+---+---+\n"
BOARD_9_LINE4 .STRINGZ "|   |   |   |\n"
BOARD_9_LINE5 .STRINGZ "+---+---+---+\n"
BOARD_9_LINE6 .STRINGZ "|   |   | 9 |\n"
BOARD_9_LINE7 .STRINGZ "+---+---+---+\n"
    .END