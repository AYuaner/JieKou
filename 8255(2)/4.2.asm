DATA SEGMENT
    T0 EQU 280H
    T1 EQU 281H
    T2 EQU 282H
    CTL53 EQU 283H
    PA EQU 288H
    PC EQU 28AH
    CTL55 EQU 28BH
    PORTC1  DB 24H,44H,04H,44H,04H,44H,04H
            DB 81H,82H,80H,82H,80H,82H,80H
            DB 0FFH
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV DX,CTL55
    MOV AL,10010000B
    OUT DX,AL
    MOV DX,PC
RE_ON:
    MOV BX,0
ON:
    MOV AL,PORTC1[BX]
    CMP AL,0FFH
    JZ  RE_ON
    OUT DX,AL
    INC BX
    
    TEST AL,21H
    JZ L0
    CALL INIT_8253_30
    JMP L1
L0:
    CALL INIT_8253_1
L1:
    PUSH DX
    MOV AH,06H
    MOV DL,0FFH
    INT 21H
    POP DX
    JZ  ON
EXIT:
    MOV AH,4CH
    INT 21H
;-----
INIT_8253_1 PROC
    PUSH DX
    PUSH AX
    MOV DX,CTL53
    MOV AL,00100101B
    OUT DX,AL
    MOV DX,T0
    MOV AL,20H
    OUT DX,AL
    MOV DX,CTL55
    MOV 01100001B
    OUT DX,AL
    MOV DX,T1
    MOV AL,10H
    OUT DX,AL
WAT1:
    MOV DX,PA
    IN  AL,DX
    AND AL,10H
    JZ  WAT1
    POP AX
    POP DX
    RET
INIT_8253_1 ENDP
;-----
INIT_8253_30 PROC
    PUSH DX
    PUSH AX
    MOV DX,CTL53
    MOV AL,00100101B
    OUT DX,AL
    MOV DX,T0
    MOV AL,40H
    OUT DX,AL
    MOV DX,CTL53
    MOV AL,01100001B
    OUT DX,AL
    MOV DX,T1
    MOV AL,0FFH
    OUT DX,AL
WAT:
    MOV DX,PA
    IN  AL,DX
    AND AL,10H
    JZ  WAT
    POP AX
    POP DX
    RET
INIT_8253_30 ENDP
CODE ENDS
ENDS START