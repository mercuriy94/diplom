#INCLUDE	"DEFINE.ASM"

START::

	SETB i2cm

Turn::
 
;������ ����� ����� (����� 04)

	lcall STARTBIT
	mov A,#10100000B   ;������ EEPROM (��������� ��� 0 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	mov A,#04H         ;������ ������ � EEPROM �� ������� ����� ���������
	lcall SENDBYTE
	lcall DELAY5

	lcall STARTBIT
	mov A,#10100001B   ;������ EEPROM (��������� ��� 1 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	lcall RCVBYTE      ;��������� ������ �����
	lcall DELAY5
	lcall STOPBIT
	mov R3,A
;���� �� ����� ��������
;����� 1 ����� �� ������˨���� ������� ���!
	mov DPP,#08h
	MOV DPTR,#0006H
	MOV A,#08H         ;������ �������
	movX @DPTR,A

	MOV A,#09H          ;���������
	movX @DPTR,A

	MOV DPTR,#0001H
	MOV A,#82H          ;���������� ���������� �������
	movX @DPTR,A
	lcall DELAY5
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;������ ������
	movX @DPTR,A

	MOV A,#0DH         ;���������
	movX @DPTR,A

	mov A,R3
	anl A,#0F0h
	RR A
	RR A
	RR A
	RR A
	ADD A,#30h
	MOV DPTR,#0001H
	movX @DPTR,A
	lcall DELAY5

;���� �� ����� ��������
;����� 2 ����� �� ��������� ������� ���!
			
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A

	mov A,R3
	anl A,#0Fh
	ADD A,#30h
	
	MOV DPTR,#0001H
	movX @DPTR,A
	mov A,#00h
	lcall line
	
;������ ����� �����
	lcall STARTBIT
	mov A,#10100000B   ;������ EEPROM (��������� ��� 0 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	mov A,#03H         ;������ ������ � EEPROM �� ������� ����� ���������
	lcall SENDBYTE
	lcall DELAY5

	lcall STARTBIT
	mov A,#10100001B   ;������ EEPROM (��������� ��� 1 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	lcall RCVBYTE      ;��������� ������ �����
	lcall DELAY5
	lcall STOPBIT
	mov R3,A


;���� �� ����� ��������
;����� 1 ����� �� ������˨���� ������� ���!
			
	MOV DPTR,#0006H
	MOV A,#0CH         ;������ ������
	movX @DPTR,A

	MOV A,#0DH         ;���������
	movX @DPTR,A

	mov A,R3
	anl A,#0F0h
	RR A
	RR A
	RR A
	RR A
	ADD A,#30h
	MOV DPTR,#0001H
	movX @DPTR,A
	lcall DELAY5

;���� �� ����� ��������
;����� 2 ����� �� ��������� ������� ���!
			
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A

	mov A,R3
	anl A,#0Fh
	ADD A,#30h
	
	MOV DPTR,#0001H
	movX @DPTR,A
	mov A,#00h
	lcall line
	
;������ �����
	lcall STARTBIT
	mov A,#10100000B   ;������ EEPROM (��������� ��� 0 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	mov A,#02H         ;������ ������ � EEPROM �� ������� ����� ���������
	lcall SENDBYTE
	lcall DELAY5

	lcall STARTBIT
	mov A,#10100001B   ;������ EEPROM (��������� ��� 1 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	lcall RCVBYTE      ;��������� ������ �����
	lcall DELAY5
	lcall STOPBIT
	mov R3,A

;����� 3 ����� �� ������˨���� ������� ���!
			
	MOV DPTR,#0006H
	MOV A,#0CH         ;������ ������
	movX @DPTR,A

	MOV A,#0DH         ;���������
	movX @DPTR,A

	mov A,R3
	anl A,#0F0h
	RR A
	RR A
	RR A
	RR A
	ADD A,#30h
	MOV DPTR,#0001H
	movX @DPTR,A
	lcall DELAY5

;���� �� ����� ��������
;����� 4 ����� �� ��������� ������� ���!
			
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A

	mov A,R3
	anl A,#0Fh
	ADD A,#30h
	
	MOV DPTR,#0001H
	movX @DPTR,A
	mov A,#00h
	lcall DELAY5

	ljmp Turn
	

;-----------------------------------------------------------------------------------

;���������!!!

line::
	lcall DELAY5
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A

	mov A,#2Dh
		
	MOV DPTR,#0001H
	movX @DPTR,A
	lcall DELAY5


SENDBYTE::

	MOV BITCNT,#8H      
	SETB MDE      
	CLR MCO       
SENDBIT::
	RLC A           
	MOV MDO,C      
	SETB MCO          
	CLR MCO         
	DJNZ BITCNT,SENDBIT
	CLR MDE
	SETB MCO
	lcall DELAY5
	JNB MDI,NEXT        
	SETB NOACK      		
NEXT::
	CLR MCO
	RET


RCVBYTE::
	mov A,00H
	MOV BITCNT,#8H
	CLR MDE             
	CLR MCO
LOOP::  
	SETB MCO
	CLR MCO
	MOV C,MDI
	RLC A    
           
	DJNZ BITCNT,LOOP   

	SETB MDE             
	SETB MDO
	SETB MCO             
	lcall DELAY5
	CLR MCO
	RET

;������ ��������
STARTBIT::

	setb MDE
	setb MDO
	setb MCO
	lcall DELAY5
	clr MDO
	lcall DELAY5
	clr MCO
	RET

;����� ��������
STOPBIT::
	
	setb MDE
	clr MCO
	clr MDO
	setb MCO
	lcall DELAY5
	setb MDO
	lcall DELAY5
	clr MDE
	RET

;��������
DELAY5::
	PUSH	PSW
	SETB	RS0   			
       	CLR	RS1



        MOV	R1,#08H			
MP1::
        MOV	R0,#0FH
MP2::
        DJNZ	R0,MP2
        DJNZ	R1,MP1

        POP	PSW
        RET	


	.END
	.END