#INCLUDE	"DEFINE.ASM"
	.ORG 0000h
	AJMP MAIN            ; jump to main program

	.ORG 004Bh

MAIN:
	mov A,#01h
	MOV ECON,#06h 
; ������ ������ �� ������ ���� 03 - ��������
;1.
	MOV EADRH,#00H
	MOV EADRL,#06H
;2. 
	MOV ECON,#01h ; 	������ EDATA1-4
	MOV EDATA1,#088H ;  	���������� ������� �����
;3. 
	MOV ECON,#05h ;  	������� ��������
	MOV ECON,#02h ; 	������ ��������
	MOV ECON,#04h 
	MOV ECON,#04h ; �������� ������
	MOV A,ECON ; ���� ��������� "0" �� �� OK!



; ������ ������ �� ������� ����� 03 - ��������
;1.
	MOV EADRH,#00H
	MOV EADRL,#06H
;2. 
	MOV ECON,#01h ; 	������ EDATA1-4
;3. 
	MOV A,EDATA1
	MOV ECON,#04h 

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