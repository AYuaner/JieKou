;/*====8259-ѧ���д�жϷ������====*/
;IRQ���ӵ�����ĸ�����

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
	INT 21H  ;���� IRQ3 ���ж�ʸ��
	IN  AL,21H  ;���ж����μĴ���
	AND AL,0F7H  ;���� IRQ3 �ж�
	OUT 21H,AL
	MOV CX,10  ;ѭ��ʮ��
	STI  ;���жϱ�־λ
L1: 
	JMP L1
INT3:  ;�жϷ������
	MOV AX,DATA
	MOV DS,AX
	MOV DX,OFFSET MSG
	MOV AH,09H
	INT 21h  ;��ʾÿ���жϵ���ʾ��Ϣ
	MOV AL,20H
	OUT 20H,AL  ;���� EOI �����ж�
	LOOP NEXT
	IN 	AL,21H  ;���ж����μĴ���
	OR 	AL,08H  ;�ر� IRQ3 �ж�
	OUT 21H,AL
	STI  ;���жϱ�־λ
	MOV AH,4CH
	INT 21H
NEXT: 
	IRET
CODE ENDS
END START