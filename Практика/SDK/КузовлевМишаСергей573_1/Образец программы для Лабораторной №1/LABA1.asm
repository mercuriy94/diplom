#INCLUDE	"DEFINE.ASM"
	.ORG 0111h
Main:
	mov	DPTR,#0111h		;������� � DPTR ������ ����� ������ �������� 

	mov	R2,#0Ah			;R0 ���������� ���-�� ����������
LoopR:
	lcall	Read
	djnz	R2,LoopR

Loop:					;����������� ����
	sjmp Loop
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Read:					;��������� ������ ������ �� ������ �������� �� ������ DPTR
	mov	A,#00h			;
	movc	A,@A+DPTR
	lcall	DIOD
	lcall	PAUSE

	inc	DPTR			;��������� ��������� ������

	ret
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DIOD:
	push	DPH			;��������� � ���� ��������� ������
	push	DPL

	mov	DPP,#08h		;����� ������� �������� ������ - �������� ����
	mov	DPTR,#0007h		;����� �������� ���������� ������������.
	movx	@DPTR,A			;��������� ������ �� ������ ���������� � A

	pop	DPL			;
	pop	DPH
	
	ret
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PAUSE:					; Delays by 10ms * A
					; 10mSec based on 16 Mhz 
	MOV		R5,#01Fh	; Acc holds delay variable (1 clock)
dl0::
	MOV		R6,#0FFh	; Set up delay loop0 (2 clocks)
dl1::
	MOV		R7,#0FFh	; Set up delay loop1 (2 clocks)
	djnz		R7,$		; Dec R3 & Jump here until R7 is 0 (3 clocks)
	djnz		R6,dl1		; Dec R2 & Jump DLY1 until R6 is 0 (3 clocks)
	djnz		R5,dl0		; Dec R1 & Jump DLY0 until R5 is 0 (3 clocks)
	RET				; RET
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
.END
