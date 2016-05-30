#INCLUDE	"DEFINE.ASM"

CLOCKSEND::

	SETB i2cm

	lcall STARTBIT
	mov A,#10100000B   ;Адресс EEPROM (последний бит 0 т.к. запись)
	lcall SENDBYTE
	lcall DELAY5
	mov A,R0         ;ячейка памяти EEPROM в которую будет производиться запись
	lcall SENDBYTE
	lcall DELAY5

	mov A,R1
	lcall SENDBYTE      ;Процедура записи байта
	lcall DELAY5
	lcall STOPBIT
	
	RET

CLOCKRCV::

	SETB i2cm

	lcall STARTBIT
	mov A,#10100000B   ;Адресс EEPROM (последний бит 0 т.к. запись)
	lcall SENDBYTE
	lcall DELAY5
	mov A,R0         ;ячейка памяти в EEPROM из которой хотим прочитать
	lcall SENDBYTE
	lcall DELAY5

	lcall STARTBIT
	mov A,#10100001B   ;Адресс EEPROM (последний бит 1 т.к. чтение)
	lcall SENDBYTE
	lcall DELAY5
	lcall RCVBYTE      ;Процедура чтения байта
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

;Начало передачи
STARTBIT::

	setb MDE
	setb MDO
	setb MCO
	lcall DELAY5
	clr MDO
	lcall DELAY5
	clr MCO
	RET

;Конец передачи
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

;задержка
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