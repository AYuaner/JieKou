DSEG SEGMENT
    T0 EQU 280H
    T1 EQU 281H
    T2 EQU 282H
    CTL EQU 283H
DSEG ENDS

CSEG SEGMENT
    ASSUME CS:CSEG,DS:DSEG
START:
    MOV AX,DSEG
    MOV DS,AX
    MOV DX,CTL
    MOV DX,00110100B
    OUT DX,AL
    MOV DX,T0
    MOV AL,D0H
    OUT DX,AL
    MOV AL,07H
    OUT DX,AL
    
    MOV AH,4CH
    INT 21H
CSEG ENDS
END START