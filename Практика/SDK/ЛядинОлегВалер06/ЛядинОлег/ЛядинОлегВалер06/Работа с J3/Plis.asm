#INCLUDE	"DEFINE.ASM"
	.ORG 0000h
	AJMP MAIN            ; jump to main program

	.ORG 004Bh

MAIN:
start::
	mov A,#03h
; ������ ������ � ������������� ����� ����
;	mov DPP,#08h
;	MOV DPTR,#0002H
;	movX A,@DPTR	
;

; ����� ���������� �� ���������� J3
;	mov DPP,#08h
;	MOV DPTR,#0004H
;	movX @DPTR,A


; ����� ���������� �� ���������� J3
	mov DPP,#08h
	MOV DPTR,#0002H
	movX A,@DPTR
	
; ����� ���������� �� ���������� J3
;	mov DPP,#08h
;	MOV DPTR,#0003H
;	movX @DPTR,A	

; ����� ���������� �� ����������
	mov DPP,#08h
	MOV DPTR,#0007H
	movX @DPTR,A	
start::

	LCALL DELAY5
	LCALL start


;��������
DELAY5::
	PUSH	PSW
	SETB	RS0   			
       	CLR	RS1



        MOV	R1,#06H			
MP1::
        MOV	R0,#05H
MP2::
        DJNZ	R0,MP2
        DJNZ	R1,MP1

        POP	PSW
        RET	


	.END
	.END