#include define.asm

CSEG
.ORG 0000h
	lJMP MAIN            ; ������� � ������� ���������
; ���������

.ORG 004Bh

MAIN:
 
	MOV	EADRL,#0		;������� �������� 0 Flash/EE ;������ ������
	MOV 	ECON,#1		;������ �������� 0
	MOV	EDATA1,ADCOFSL	 ;�������� ������ 
	MOV	EDATA2,ADCOFSH 	; ������������� � 	;EDATA1,2,3,4
	MOV	EDATA3,ADCGAINL
	MOV	EDATA4,ADCGAINH
	MOV	ECON,#5		; ������� �������� 0
	MOV	ECON,#2		; ������ ;������������� � ;EDATA1,2,3,4 ��  
; �������� 0 Flash/EE ������ 
	
;��������� ��� ���������� ����������� ������ ���������� � 
;��������������� ��������.
	MOV	EADRL,#0		;������� �������� 0 ;Flash/EE ;������ ;������
	MOV 	ECON,#1		;������ �������� 0
	MOV	ADCOFSL, EDATA1	 ;�������������� ;�������������  
	MOV	ADCOFSH, EDATA2 	; ;���������� �� ;EDATA1,2,3,4
	MOV	ADCGAINL, EDATA3
	MOV	ADCGAINH, EDATA4
.END
.END