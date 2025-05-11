;; Convert 260 C(Celsius) to F(Fahrenheit)

ORG 0100h


.DATA
RESULT DW ? 
   

.CODE
MAIN PROC

    MOV AX, 260 
    MOV BX, 18    
    MUL BX
    
    MOV BX, 10
    DIV BX
          
    ADD AX, 32

    MOV RESULT, AX
      
    
MAIN ENDP

END MAIN
