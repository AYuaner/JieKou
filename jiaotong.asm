data segment
T0  EQU  280H    ;T0---CTL  为计数器 0----控制寄存器的地址        
T1  EQU  281H        
T2  EQU  282H        
CTL1 EQU  283H 
io8255a equ 288h   
io8255c equ 28ah
io8255ctl equ 28bh
portc1 db 24h, 44h, 04h, 44h, 04h, 44h, 04h ;六个灯可能
db 81h, 82h, 80h, 82h, 80h, 82h, 80h ;的状态数据
db 0ffh ;结束标志
data ends
code segment
assume cs:code, ds:data
start:
mov ax, data
mov ds, ax
mov dx, io8255ctl
mov al, 10010000B
out dx, al ;设置 8255 为 C 口输出
mov dx, io8255c
re_on:
mov bx,0
on:
mov al, portc1[bx]
cmp al, 0ffh
jz re_on
out dx, al ;点亮相应的灯
inc bx

test al,  21h ;是否有绿灯亮
jz L0 ;没有,短延时
CALL Init_8253_30
jmp L1;
L0:
CALL Init_8253_1 
L1:
push dx
mov ah, 06h
mov dl, 0ffh
int 21h
pop dx ;判断是否有按键
jz on ;没有,转到 on
exit:
mov ah,4ch ;返回
int 21h

;=================初始化 8253_1================================== 
Init_8253_1  PROC; 
PUSH DX      
PUSH AX      ;/*8253 产生 1S 的连续方波      
MOV DX,CTL1      
MOV AL,00100101B  ;选择通道 0，写入高字节，方式 2，用 BCD 码      
OUT  DX,AL      
MOV  DX,T0      
MOV  AL,20H      
OUT  DX,AL      ;设置第二级      
MOV DX,CTL1      
MOV AL,01100001B  ;选择通道 1，写入高字节，方式 0，用 BCD 码      
OUT  DX,AL      
MOV  DX,T1      
MOV  AL,10H      
OUT  DX,AL      ;8253 产生 1S 的连续方波*/  
WAT1:    
MOV DX,io8255a ;读 a 口   
IN AL,DX   
AND AL,10H   ;检测 PC4  
JZ WAT1; 
POP AX      
POP DX      
RET 
Init_8253_1 ENDP 
;=================初始化 8253_30================================== 
Init_8253_30  PROC; 
PUSH DX      
PUSH AX      ;/*8253 产生 30S 的连续方波      
MOV DX,CTL1      
MOV AL,00100101B  ;选择通道 0，写入高字节，方式 2，用 BCD 码      
OUT  DX,AL      
MOV  DX,T0      
MOV  AL,40H      
OUT  DX,AL      ;设置第二级      
MOV DX,CTL1      
MOV AL,01100001B  ;选择通道 1，写入高字节，方式 0，用 BCD 码      
OUT  DX,AL      
MOV  DX,T1      
MOV  AL,0f0H      
OUT  DX,AL      ;8253 产生 30S 的连续方波*/  
WAT:    
MOV DX,io8255a ;读 a 口   
IN AL,DX   
AND AL,10H   ;检测 PC4  
JZ WAT; 

POP AX      
POP DX      
RET 
Init_8253_30 ENDP 
code ends
end start