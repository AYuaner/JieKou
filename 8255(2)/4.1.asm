;利用并行接口8255实现十字路口交通灯的模拟控制，时延用循环实现
DATA SEGMENT
    IO8255C EQU 28AH
    IO825GCTL   EQU 28BH
    PERTC1  DB  24H,44H,04H,44H,04H,44H,04H
            DB  81H,82H,80H,82H,80H,82H,80H
            DB  0FFH
DATA ENDS

CODE SEGMENT
    ASSUME  CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV DX,IO8255CTL
    MOV AL,10010000B
    OUT DX,AL
    MOV DX,IO8255C
RE_ON:
    MOV BX,0
ON:
    MOV AL,PORTC1[BX]
    CMP AL,0FFH
    JZ  RE_ON
    OUT DX,AL
    INC BX
    MOV CX,200
    TEST    AL,21H
    JZ L0
    MOV CX,2000
L0:
    MOV DI,9000
L1:
    DEC DI
    JNZ L1
    LOOP L0
    JMP ON
EXIT:
    MOV AH,4CH
    INT 21H
CODE ENDS
END START