#INCLUDE	"DEFINE.ASM"

CLOCKSEND::

	SETB i2cm

	lcall STARTBIT
	mov A,#10100000B   ;������ EEPROM (��������� ��� 0 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	mov A,R0         ;������ ������ EEPROM � ������� ����� ������������� ������
	lcall SENDBYTE
	lcall DELAY5

	mov A,R1
	lcall SENDBYTE      ;��������� ������ �����
	lcall DELAY5
	lcall STOPBIT
	
	RET

CLOCKRCV::

	SETB i2cm

	lcall STARTBIT
	mov A,#10100000B   ;������ EEPROM (��������� ��� 0 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	mov A,R0         ;������ ������ � EEPROM �� ������� ����� ���������
	lcall SENDBYTE
	lcall DELAY5

	lcall STARTBIT
	mov A,#10100001B   ;������ EEPROM (��������� ��� 1 �.�. ������)
	lcall SENDBYTE
	lcall DELAY5
	lcall RCVBYTE      ;��������� ������ �����
	lcall DELAY5
	lcall STOPBIT
	mov R1,A
	
	RET

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