#include define.asm
LED        .EQU	P3
CHAN    .EQU	1000B               ; выбор канала АЦП (0-8) в 10-ной системе
	                          ; 
;____________________________________________________________________
                                                  ; начало
CSEG

.ORG 0000h
		
	lJMP MAIN            ; jump to main program

; прога
.ORG 004Bh

MAIN:

; PRECONFIGURE...
    	MOV     T3CON,#83h	; настройка вывода 	
	MOV     T3FD,#02Dh		; в порт
	MOV     SCON,#52h		; UART (COM-порт)
	MOV     ADCCON1,#0ACh         ; насторойка регистра АЦП
	MOV     ADCCON2,#CHAN      ; выбор установленного канала
	MOV     DACCON,#03DH	; установка ЦАП 0-5В 12бит
	CPL      LED                                  ; CPL LED with each transmission

	MOV     A,#01H		; задержка
	SETB    SCONV                            ; инициализация АЦП преобразования
        		         
	JNB     ADCI,$		;бит прерываняия АЦП установливается однократно по 				;концу однократного цикла преобразования АЦП
	CLR	ADCI		;обнуление бита прерывания 
;исходные данные:
	MOV     DAC0H,ADCDATAH     ; вывод ЦАПа
	MOV     DAC0L,ADCDATAL
	MOV     R1,ADCDATAH             ; вывод результата в пару HL ЦАПа 
	MOV     R2,ADCDATAL               ; Младший разряд

;регистры выходных данных

	mov R3,#00h  ;Стоарший
	mov R4,#00h  ;младший


;===========Умножение 16 ричного числа на 1.5==============	

	mov A,R1
	RRC A
	mov R3,A

 	mov A,R2
	RRC A
	ADD A,R2
	mov R2,A
	
	mov A,R3
	ADDC A,R1
	mov R1,A
	mov R3,#00h

;=======перевод в 10_ую систему исчиления==============

;Первый цикл для старших разрядов
	mov R0,#08h
cicl1::
;Сдвиг двоичного числа влево
	mov A,R1
	RLC A
	mov R1,A
;Двоично-десятичное удвоение суммы
	mov A,R4
	ADDC A,R4
	DA A
	mov R4,A
	mov A,R3
	ADDC A,R3
	DA A
	mov R3,A
	DJNZ R0,cicl1

;Второй цикл для младших разрядов
	mov R0,#08h
cicl2::
;Сдвиг двоичного числа влево
	mov A,R2
	RLC A
	mov R2,A
;Двоично-десятичное удвоение суммы
	mov A,R4
	ADDC A,R4
	DA A
	mov R4,A
	mov A,R3
	ADDC A,R3
	DA A
	mov R3,A
	DJNZ R0,cicl2	
 
;Начало вывода символов на ЖКИ экран стенда
	mov R5,#02H
	mov DPP,#08h
;Выод на экран символов
;Вывод 1 цыфры на ОПРЕДЕЛЁННУЮ позицию ЖКИ!

	MOV DPTR,#0006H
	MOV A,#08H         ;Запись команды
	movX @DPTR,A
	
	MOV A,#09H          ;Разрешить
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#82H          ;Определяем координаты символа
	movX @DPTR,A
	lcall PAUSE 
		
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
		
	lCALL     SENDCHAR

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 
	
;Вывод запятой в ОПРЕДЕЛЁННУЮ позицию ЖКИ!

	MOV DPTR,#0006H
	MOV A,#08H         ;Запись команды
	movX @DPTR,A
	
	MOV A,#09H          ;Разрешить
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#83H          ;Определяем координаты символа
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;Запись данных
	movX @DPTR,A
	
	MOV A,#0DH         ;Разрешить
	movX @DPTR,A

	mov A,#00101100B
			
	lCALL     SENDCHAR

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 
;Вывод 2 цыфры на следующую позицию ЖКИ!

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

	mov A,R3
	anl A,#0Fh
	ADD A,#30h
	
	lCALL     SENDCHAR

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 

;Вывод 3 цыфры на следующую позицию ЖКИ!

	MOV DPTR,#0006H
	MOV A,#08H         ;Запись команды
	movX @DPTR,A
	
	MOV A,#09H          ;Разрешить
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#85H          ;Определяем координаты символа
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;Запись данных
	movX @DPTR,A
	
	MOV A,#0DH         ;Разрешить
	movX @DPTR,A

	mov A,R4
	anl A,#0F0h
	RR A
	RR A
	RR A
	RR A

	ADD A,#30h

	lCALL     SENDCHAR
	
	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE  

;Вывод 4 цыфры на следующую позицию ЖКИ!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#86H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A

	mov A,R4
	anl A,#0Fh
	ADD A,#30h
	
	lCALL     SENDCHAR	

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 

;Пробел	
	MOV      A, #20H
	lCALL     SENDCHAR

;Вывод Вольт!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#88H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A

	mov A,#01000010B
	
	lCALL     SENDCHAR	

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 
		
;Конец вывода цыфр
; Every eight transmissions start on a new line
                  MOV      A, #10       ; Transmit a linefeed
	lCALL     SENDCHAR
	MOV      A, #13       ; Transmit a carriage return
	lCALL     SENDCHAR
	
;задержка 5с между снятиями данных
	lCALL DELAY 
	ljmp MAIN


;ВЫВОД ЗНАЧЕНИЯ НА ЭКРАН ЧЕРЕЗ UART (в Giper Terminal)
;=======процедура вывода символа по его ASCII-коду======================
                                                           ; SENDCHAR

SENDCHAR:       ; sends ASCII value contained in A to UART

        	JNB     TI,$            ; wait til present char gone
	CLR     TI              ; must clear TI
	MOV     SBUF,A

	RET

;=======процедур вывода переменной==================================
                                                            ; SENDVAL

SENDVAL:        ; converts the hex value of A into two ASCII chars,
		; and then spits these two characters up the UART.
                ; does not change the value of A.

        PUSH    ACC
        SWAP    A
        lCALL    HEX2ASCII
        lCALL    SENDCHAR        ; send high nibble
        POP     ACC
        PUSH    ACC
        lCALL    HEX2ASCII
        lCALL    SENDCHAR        ; send low nibble
        POP     ACC

        RET


;====конвертирование символа в ASCII-код==============================
                                                          ; HEX2ASCII

HEX2ASCII:      ; converts A into the hex character representing the
                ; value of A's least significant nibble

        ANL     A,#00Fh
        CJNE    A,#00Ah,$+3
        JC      IO0030
        ADD     A,#007h
IO0030: ADD     A,#'0'

        RET

;======================пауза на вывод символа========================
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

;===================задержка 5с====================================
DELAY:					; Delays by 100ms * A
					; 100mSec based on 2.097152MHZ 
					; Core Clock 
					; 
	
	MOV	R5,#400		; Acc holds delay variable (1 clock)
DLY0:	MOV	R6,#05Bh	; Set up delay loop0 (2 clocks)
DLY1:	MOV	R7,#0FFh	; Set up delay loop1 (2 clocks)
	DJNZ	R7,$		; Dec R7 & Jump here until R7 is 0 (3 clocks)
	DJNZ	R6,DLY1         ; Dec R6 & Jump DLY1 until R6 is 0 (3 clocks)
	DJNZ	R5,DLY0		; Dec R5 & Jump DLY0 until R5 is 0 (3 clocks)
	RET			; Return from subroutine          
	
	.END
	


	

