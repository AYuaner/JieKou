DATA SEGMENT
    T0 EQU 280H
    T1 EQU 281H
    T2 EQU 282H
    CTL53 EUQ 283H
    PA EQU 288H
    PB EQU 289H
    PC EQU 28AH
    CTL55 EQU 28BH
    LTABLE  DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H
            DB 7FH,6FH,77H,7CH,39H,5EH,79H,71H
    DAT DB 21H
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV CX,16
    CALL INIT55
AGAIN:
    CALL READ_PA
    CALL DISP_DAT
    JMP AGAIN
    
    MOV AH,4CH
    INT 21H
;-----
LED_1 PROC
    LEA SI,LTABLE
    ADD SI,BX
    MOV AL,[SI]
    AND AL,7FH
    MOV DX,PB
    OUT DX,AL
    RET
LED_1 ENDP
;-----
LED_S PROC
    PUSH CX
    PUSH BX
    
    MOV DX,PC
    MOV AL,0H
    OUT DX,AL
    MOV BH,0
    AND BL,0FH
    CALL LED_1
    MOV DX,PC
    MOV AL,1H
    OUT DX,AL
    
    POP BX
    POP CX
    RET
LED_S ENDP
;-----
READ_PA PROC
    PUSH DX
    PUSH AX
LOOP_CHECK:
    MOV BH,0
    MOV BL,DAT
    CALL LED_S
    MOV DX,PC
    IN  AL,DX
    TEST AL,80H
    JNZ LOOP_CHECK
    MOV DX,PA
    IN  AL,DX
    MOV DAT,AL

    POP AX
    POP DX
    RET
READ_PA ENDP
;-----
DISP_DAT PROC
    PUSH DX
    PUSH AX
    PUSH CX
    
    MOV AL,DAT
    MOV CL,4
    SHR AL,CL
    AND AL,0FH

    CMP AL,0AH
    JC  S1
    ADD AL,7H
S1:
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H 

    MOV AL,DAT
    AND AL,0FH
    CMP AL,0AH
    JC  S2
    ADD AL,7H 
S2:
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H 

    MOV DL,' '
    MOV AH,02H
    INT 21H 

    POP CX
    POP AX
    POP DX
    RET
DISP_DAT ENDP
;-----
INIT55 PROC
    PUSH DX
    PUSH AX

    MOV DX,CTL55
    MOV AL,98H
    OUT DX,AL

    POP AX
    POP DX
    RET
INIT55 ENDP
CODE ENDS
END START
