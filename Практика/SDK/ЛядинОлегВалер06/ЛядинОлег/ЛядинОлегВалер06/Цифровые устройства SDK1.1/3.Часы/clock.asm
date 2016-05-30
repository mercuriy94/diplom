#INCLUDE	"DEFINE.ASM"

START::

	SETB i2cm

Turn::
 
;Чтение байта часов (адрес 04)

	lcall STARTBIT
	mov A,#10100000B   ;Адресс EEPROM (последний бит 0 т.к. запись)
	lcall SENDBYTE
	lcall DELAY5
	mov A,#04H         ;ячейка памяти в EEPROM из которой хотим прочитать
	lcall SENDBYTE
	lcall DELAY5

	lcall STARTBIT
	mov A,#10100001B   ;Адресс EEPROM (последний бит 1 т.к. чтение)
	lcall SENDBYTE
	lcall DELAY5
	lcall RCVBYTE      ;Процедура чтения байта
	lcall DELAY5
	lcall STOPBIT
	mov R3,A
;Выод на экран символов
;Вывод 1 цыфры на ОПРЕДЕЛЁННУЮ позицию ЖКИ!
	mov DPP,#08h
	MOV DPTR,#0006H
	MOV A,#08H         ;Запись команды
	movX @DPTR,A

	MOV A,#09H          ;Разрешить
	movX @DPTR,A

	MOV DPTR,#0001H
	MOV A,#82H          ;Определяем координаты символа
	movX @DPTR,A
	lcall DELAY5
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;Запись данных
	movX @DPTR,A

	MOV A,#0DH         ;Разрешить
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

;Выод на экран символов
;Вывод 2 цыфры на следующую позицию ЖКИ!
			
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
	
;Чтение байта минут
	lcall STARTBIT
	mov A,#10100000B   ;Адресс EEPROM (последний бит 0 т.к. запись)
	lcall SENDBYTE
	lcall DELAY5
	mov A,#03H         ;ячейка памяти в EEPROM из которой хотим прочитать
	lcall SENDBYTE
	lcall DELAY5

	lcall STARTBIT
	mov A,#10100001B   ;Адресс EEPROM (последний бит 1 т.к. чтение)
	lcall SENDBYTE
	lcall DELAY5
	lcall RCVBYTE      ;Процедура чтения байта
	lcall DELAY5
	lcall STOPBIT
	mov R3,A


;Выод на экран символов
;Вывод 1 цыфры на ОПРЕДЕЛЁННУЮ позицию ЖКИ!
			
	MOV DPTR,#0006H
	MOV A,#0CH         ;Запись данных
	movX @DPTR,A

	MOV A,#0DH         ;Разрешить
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

;Выод на экран символов
;Вывод 2 цыфры на следующую позицию ЖКИ!
			
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
	
;Чтение байта
	lcall STARTBIT
	mov A,#10100000B   ;Адресс EEPROM (последний бит 0 т.к. запись)
	lcall SENDBYTE
	lcall DELAY5
	mov A,#02H         ;ячейка памяти в EEPROM из которой хотим прочитать
	lcall SENDBYTE
	lcall DELAY5

	lcall STARTBIT
	mov A,#10100001B   ;Адресс EEPROM (последний бит 1 т.к. чтение)
	lcall SENDBYTE
	lcall DELAY5
	lcall RCVBYTE      ;Процедура чтения байта
	lcall DELAY5
	lcall STOPBIT
	mov R3,A

;Вывод 3 цыфры на ОПРЕДЕЛЁННУЮ позицию ЖКИ!
			
	MOV DPTR,#0006H
	MOV A,#0CH         ;Запись данных
	movX @DPTR,A

	MOV A,#0DH         ;Разрешить
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

;Выод на экран символов
;Вывод 4 цыфры на следующую позицию ЖКИ!
			
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

;Процедуры!!!

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