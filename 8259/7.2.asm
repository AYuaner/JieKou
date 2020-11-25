DATA SEGMENT
         PA  EQU  288H           
         PB  EQU  289H        
         PC  EQU  28AH        
         CTL EQU  28BH  
         MSG DB 'TPCA Interrupt!',0DH,0AH,'$'
         LTABLE   DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H                 
                  DB 7FH,6FH,77H,7CH,39H,5EH,79H,71H  
         DAT      DB 07H 
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
mov ax, cs
mov ds, ax
mov dx, offset int3
mov ax, 250bh
int 21h ;���� IRQ3 ���ж�ʸ��
in al, 21h ;���ж����μĴ���
and al, 0f7h ;���� IRQ3 �ж�
out 21h, al
mov cx, 10 ;���� IRQ3 �ж�
sti ;���жϱ�־λ
CALL Init_8255; 
mov ax, data
mov ds, ax 

L1: 
MOV  BH,0      
MOV  BL,Cl 
neg bl
add bl,10
CALL LED_S   
jmp L1


int3: ;�жϷ������
mov ax, data
mov ds, ax 
             
MOV DX, PA      
IN  AL, DX      
MOV DAT, AL 

mov dx, offset mess
mov ah, 09
int 21h ;��ʾÿ���жϵ���ʾ��Ϣ
mov al, 20h
out 20h, al ;���� EOI �����ж�
loop next
in al, 21h ;���ж����μĴ���
or al, 08h ;�ر� IRQ3 �ж�
out 21h,  al
sti ;���жϱ�־λ
mov ah, 4ch
int 21h
next: iret

  ;==============�������ʾ�ַ�����==================== 
LED_1   PROC    ;��ʾ�ַ�����        
LEA    SI, LTABLE         
ADD   SI, BX         
MOV   AL,[SI]         
AND   AL,7FH    ;���λ��Ϊ 0���Բ���ʾС����        
MOV   DX,PB         
OUT   DX,AL         
RET 
LED_1         ENDP  
LED_S   PROC         
       
PUSH      BX                        
MOV       DX,PC  ;Ϣλ��         
MOV       AL,0H         
OUT       DX,AL  
MOV       BH,0         
AND       BL,0FH   ;��ʾ����λ        
CALL       LED_1        
MOV       DX,PC  ;ѡ�����λ,�� PC0 ��Ϊ 1         
MOV       AL,1H         
OUT       DX,AL   
MOV       DX,PC  ; Ϩλ��         
MOV       AL,0H         
OUT       DX,AL            
POP       BX         
PUSH      BX  
MOV       BH,0  
PUSH      CX         
MOV       CL,4   
SHR        BL,CL 
pop   cx        
AND       BL,0FH   ;��ʾ����λ         
CALL       LED_1          
MOV       DX,PC   ;ѡ�����λ���� PC1 ��Ϊ 1        
MOV       AL,02H         
OUT        DX,AL   
MOV       DX,PC  ;Ϩλ��         
MOV       AL,0H         
OUT       DX,AL                 
POP       BX         
RET 
LED_S   ENDP 
;======================��ʼ�� 8255========================== 
Init_8255 PROC;      
PUSH DX      
PUSH AX             
MOV DX,CTL  ;8255 ��ʽ�ֿ���   ;10011000      
MOV AL,98H      
OUT DX,AL  
POP AX      
POP DX      
RET 
Init_8255  ENDP  

code ends
end start