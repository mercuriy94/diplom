#INCLUDE	"DEFINE.ASM"


start::
	mov DPP,#08h
SVETODIOD::

;�������� �������!!!

	MOV DPTR,#0006H
	MOV A,#08H         ;������ �������
	movX @DPTR,A
	
	MOV A,#09H         ;���������
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#1cH         ;��� ������� �������� �������
	movX @DPTR,A
	lcall PAUSE 

;���� �� ����� ��������
;����� ����� "L" �� ������˨���� ������� ���!

	MOV DPTR,#0006H
	MOV A,#08H         ;������ �������
	movX @DPTR,A
	
	MOV A,#09H          ;���������
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#82H          ;���������� ���������� �������
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;������ ������
	movX @DPTR,A
	
	MOV A,#0DH         ;���������
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#4CH         ;��� ����� "L"
	movX @DPTR,A
	lcall PAUSE 

;����� ����� "�" �� ��������� ������� ���!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#83H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#45H
	movX @DPTR,A
	lcall PAUSE 

;����� ����� "R" �� ��������� ������� ���!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#84H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#52H
	movX @DPTR,A
	lcall PAUSE  

;����� ����� "�" �� ��������� ������� ���!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#85H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#41H
	movX @DPTR,A

;����� ������ ����

	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE 

	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE

	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE	

	
	ljmp SVETODIOD


PAUSE::                             	
        PUSH	PSW
	SETB	RS0   			
       	CLR	RS1



        MOV	R1,#9CH			
MP1::
        MOV	R0,#92H
MP2::
        DJNZ	R0,MP2
        DJNZ	R1,MP1

        POP	PSW
        RET	

	.END
	
