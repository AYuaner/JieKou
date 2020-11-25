;/*====8259-学会编写中断服务程序====*/
;IRQ连接单脉冲的负脉冲

DATA SEGMENT
	MSG DB 'TPCA Interrupt!',0DH,0AH,'$'
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,CS
	MOV DS,AX
	MOV DX,OFFSET INT#
	MOV AX,250BH
	INT 21H  ;设置 IRQ3 的中断矢量
	IN  AL,21H  ;读中断屏蔽寄存器
	AND AL,0F7H  ;开放 IRQ3 中断
	OUT 21H,AL
	MOV CX,10  ;循环十次
	STI  ;置中断标志位
L1: 
	JMP L1
INT3:  ;中断服务程序
	MOV AX,DATA
	MOV DS,AX
	MOV DX,OFFSET MSG
	MOV AH,09H
	INT 21h  ;显示每次中断的提示信息
	MOV AL,20H
	OUT 20H,AL  ;发出 EOI 结束中断
	LOOP NEXT
	IN 	AL,21H  ;读中断屏蔽寄存器
	OR 	AL,08H  ;关闭 IRQ3 中断
	OUT 21H,AL
	STI  ;置中断标志位
	MOV AH,4CH
	INT 21H
NEXT: 
	IRET
CODE ENDS
END START