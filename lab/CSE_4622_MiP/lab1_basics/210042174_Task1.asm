;;(30 + 15) x (575 - 225) + 210

ORG 0100h


.DATA
SUM DW ?
DIFF DW ?
RESULT DW ? 
   

.CODE
MAIN PROC
    MOV AX, 30           
    ADD AX, 15  
    MOV SUM, AX      
    
    MOV BX, 575
    SUB BX, 225
    MOV DIFF, BX
    
    MUL BX
    ADD AX, 210
    
    MOV RESULT, AX
      
    
MAIN ENDP

END MAIN
