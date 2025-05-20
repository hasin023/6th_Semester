ORG 0100h


.DATA
CHAR DB ? 
   

.CODE
MAIN PROC
    ; display prompt
    MOV AH, 2
    MOV DL, '?'
    INT 21h
    
    ; input a character
    MOV AH, 1
    INT 21h
    MOV CHAR, AL
    MOV BL, AL 
    
    ; go to a new line with carriage return
    MOV AH, 2
    MOV DL, 0DH
    INT 21h
    MOV DL, 0AH
    INT 21h    
    
    ; divide by 2
    MOV AL, BL      
    MOV AH, 0      
    MOV BL, 2
    DIV BL               ;AH = reminder

    CMP AH, 0          
    JE PRINT_E
    JMP PRINT_O      
    
    
PRINT_O:
    MOV DL, 'O'
    JMP DISPLAY

PRINT_E:
    MOV DL, 'E'            
        
        
; display character
DISPLAY:
    MOV AH, 2
    INT 21h

    ; return to DOS
    MOV AH, 4CH
    INT 21H
      
    
MAIN ENDP

END MAIN