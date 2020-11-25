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
int 21h ;设置 IRQ3 的中断矢量
in al, 21h ;读中断屏蔽寄存器
and al, 0f7h ;开放 IRQ3 中断
out 21h, al
mov cx, 10 ;开放 IRQ3 中断
sti ;置中断标志位
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


int3: ;中断服务程序
mov ax, data
mov ds, ax 
             
MOV DX, PA      
IN  AL, DX      
MOV DAT, AL 

mov dx, offset mess
mov ah, 09
int 21h ;显示每次中断的提示信息
mov al, 20h
out 20h, al ;发出 EOI 结束中断
loop next
in al, 21h ;读中断屏蔽寄存器
or al, 08h ;关闭 IRQ3 中断
out 21h,  al
sti ;置中断标志位
mov ah, 4ch
int 21h
next: iret

  ;==============数码管显示字符程序==================== 
LED_1   PROC    ;显示字符程序        
LEA    SI, LTABLE         
ADD   SI, BX         
MOV   AL,[SI]         
AND   AL,7FH    ;最高位设为 0，以不显示小数点        
MOV   DX,PB         
OUT   DX,AL         
RET 
LED_1         ENDP  
LED_S   PROC         
       
PUSH      BX                        
MOV       DX,PC  ;息位码         
MOV       AL,0H         
OUT       DX,AL  
MOV       BH,0         
AND       BL,0FH   ;显示低四位        
CALL       LED_1        
MOV       DX,PC  ;选择低四位,即 PC0 置为 1         
MOV       AL,1H         
OUT       DX,AL   
MOV       DX,PC  ; 熄位码         
MOV       AL,0H         
OUT       DX,AL            
POP       BX         
PUSH      BX  
MOV       BH,0  
PUSH      CX         
MOV       CL,4   
SHR        BL,CL 
pop   cx        
AND       BL,0FH   ;显示高四位         
CALL       LED_1          
MOV       DX,PC   ;选择高四位，即 PC1 置为 1        
MOV       AL,02H         
OUT        DX,AL   
MOV       DX,PC  ;熄位码         
MOV       AL,0H         
OUT       DX,AL                 
POP       BX         
RET 
LED_S   ENDP 
;======================初始化 8255========================== 
Init_8255 PROC;      
PUSH DX      
PUSH AX             
MOV DX,CTL  ;8255 方式字控制   ;10011000      
MOV AL,98H      
OUT DX,AL  
POP AX      
POP DX      
RET 
Init_8255  ENDP  

code ends
end start