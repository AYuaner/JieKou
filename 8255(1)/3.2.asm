DATA SEGMENT
    T0 EQU 280H
    T1 EQU 281H
    T2 EQU 282H
    CTL1 EQU 283H
    PA EQU 288H
    PB EQU 289H
    PC EQU 28AH
    CTL55 EQU 283H
    LTABLE DB 10 DUP(?)
DATA ENDS

STACK1 SEGMENT PARA STACK
    DW 20H DUP(0)
STACK1 ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV DX,CTL55
    MOV AL,10010001B
    OUT DX,AL
    CALL INIT8253
WAT:
    MOV DX,PC
    IN  AL,DX
    AND AL,01H
    JNZ WAT
    
    MOV DX,PA
    IN  AL,DX
    MOV DX,PB
    OUT DX,AL
    MOV LTABLE[SI],AL
WAT1:
    MOV DX,PC
    IN  AL,DX
    AND AL,01H
    JZ  WAT1
    MOV AH,4CH
    INT 21H
INIT8253 PROC
    PUSH DX
    PUSH AX
    MOV DX,CTL1
    MOV AL,00100101B
    OUT DX,AL
    MOV DX,T0
    MOV AL,20H
    OUT DX,AL
    
    MOV DX,CTL1
    MOV AL,01100111B
    OUT DX,AL
    MOV DX,T1
    MOV AL,10H
    OUT DX,AL
    POP AX
    POP DX
    RET
INIT8253 ENDP
CODE ENDS
END START