;延时法，16次产生锯齿波，最高点-5v
DATE SEGMENT
DATA ENDS

STACK1 SEGMENT PARA STACK
    DW 20H DUP(0)
STACK1 ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK1
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV AL,00H
AGAIN:
    MOV DX,280H
    OUT DX,AL
    CALL DELAY
    ADD AL,10H
    JMP AGAIN
    MOV AH,4CH
    INT 21H
;-----
DELAY PROC NEAR
    PUSH CX
    MOV CX,0FFFFH
L1:
    LOOP L1
    MOV CX,0FFFFH
L2:
    LOOP L2
    POP CX
    RET
DELAY ENDP
CODE ENDS
END START