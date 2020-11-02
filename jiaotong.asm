data segment
T0  EQU  280H    ;T0---CTL  Ϊ������ 0----���ƼĴ����ĵ�ַ        
T1  EQU  281H        
T2  EQU  282H        
CTL1 EQU  283H 
io8255a equ 288h   
io8255c equ 28ah
io8255ctl equ 28bh
portc1 db 24h, 44h, 04h, 44h, 04h, 44h, 04h ;�����ƿ���
db 81h, 82h, 80h, 82h, 80h, 82h, 80h ;��״̬����
db 0ffh ;������־
data ends
code segment
assume cs:code, ds:data
start:
mov ax, data
mov ds, ax
mov dx, io8255ctl
mov al, 10010000B
out dx, al ;���� 8255 Ϊ C �����
mov dx, io8255c
re_on:
mov bx,0
on:
mov al, portc1[bx]
cmp al, 0ffh
jz re_on
out dx, al ;������Ӧ�ĵ�
inc bx

test al,  21h ;�Ƿ����̵���
jz L0 ;û��,����ʱ
CALL Init_8253_30
jmp L1;
L0:
CALL Init_8253_1 
L1:
push dx
mov ah, 06h
mov dl, 0ffh
int 21h
pop dx ;�ж��Ƿ��а���
jz on ;û��,ת�� on
exit:
mov ah,4ch ;����
int 21h

;=================��ʼ�� 8253_1================================== 
Init_8253_1  PROC; 
PUSH DX      
PUSH AX      ;/*8253 ���� 1S ����������      
MOV DX,CTL1      
MOV AL,00100101B  ;ѡ��ͨ�� 0��д����ֽڣ���ʽ 2���� BCD ��      
OUT  DX,AL      
MOV  DX,T0      
MOV  AL,20H      
OUT  DX,AL      ;���õڶ���      
MOV DX,CTL1      
MOV AL,01100001B  ;ѡ��ͨ�� 1��д����ֽڣ���ʽ 0���� BCD ��      
OUT  DX,AL      
MOV  DX,T1      
MOV  AL,10H      
OUT  DX,AL      ;8253 ���� 1S ����������*/  
WAT1:    
MOV DX,io8255a ;�� a ��   
IN AL,DX   
AND AL,10H   ;��� PC4  
JZ WAT1; 
POP AX      
POP DX      
RET 
Init_8253_1 ENDP 
;=================��ʼ�� 8253_30================================== 
Init_8253_30  PROC; 
PUSH DX      
PUSH AX      ;/*8253 ���� 30S ����������      
MOV DX,CTL1      
MOV AL,00100101B  ;ѡ��ͨ�� 0��д����ֽڣ���ʽ 2���� BCD ��      
OUT  DX,AL      
MOV  DX,T0      
MOV  AL,40H      
OUT  DX,AL      ;���õڶ���      
MOV DX,CTL1      
MOV AL,01100001B  ;ѡ��ͨ�� 1��д����ֽڣ���ʽ 0���� BCD ��      
OUT  DX,AL      
MOV  DX,T1      
MOV  AL,0f0H      
OUT  DX,AL      ;8253 ���� 30S ����������*/  
WAT:    
MOV DX,io8255a ;�� a ��   
IN AL,DX   
AND AL,10H   ;��� PC4  
JZ WAT; 

POP AX      
POP DX      
RET 
Init_8253_30 ENDP 
code ends
end start