#include define.asm

                                                  ; Начало
CSEG
.ORG 0000h
        lJMP	MAIN            ; переход к главной программе
	   	
;====================================================================
                                                       ; Основная программа
.ORG 004Bh
MAIN:

; Разметка внешней пямяти.

	MOV	ADCOFSH,#20h	; установка коэффициентов калибровки
	MOV	ADCOFSL,#00h
	MOV	ADCGAINH,#20h
	MOV	ADCGAINL,#00h
	

	MOV	ADCCON1,#00h                                   ;перевод АЦП в дежурный режим
	MOV     DPL,#00H    ; установка указателя DPTR на нулевой адрес 
	MOV     DPH,#00H    ;
	MOV     DPP,#00H    ; 


	MOV	DMAL,#0
	MOV	DMAH,#0
	MOV	DMAP,#0


SETUP:	
	mov	R1,#03h        ; регистр для создания цикла

CICLE:
	MOV     A,#080h      		; выбор канала температурного сенсора
        	MOVX    @DPTR,A       	;запись идентификатора канала в старший разряд ячейки памяти 
        	INC     DPTR		;переход к следующей ячейки
	CLR     A              		 ; обнуление байта 
       	 MOVX    @DPTR,A		; обнуление ячейки памяти - будет записан результат преобразования
        	INC     DPTR

        	DEC	R1		; декремент цикла
	CJNE	R1,#00h,CICLE	; переход, если цикл не закончин
	mov	R1,00h

        MOV     A,#080h     		 ; повтор послееднего канала.
        MOVX    @DPTR,A         		; для передачи команды "СТОП КПД"
        INC     DPTR
        CLR     A
        MOVX    @DPTR,A
        INC     DPTR

        MOV     A,#0F0h         		; команда "СТОП КПД"
        MOVX    @DPTR,A

;Конфигурация АЦП преобразования


	MOV     ADCCON1,#0ACh   
	SETB	CCONV
	SETB	DMA

;        lJMP     MAIN

	JNB	ADCI,$
	CLR	ADCI	

	mov	R1,#00h
	mov	R2,#00h
	mov	R3,#00h

	ljmp	start

CR1:	inc	R1
        	ljmp	start

CR2:	inc	R2
	ljmp	start


CR3:	inc	R3
	ljmp	start

; процедура вывода содержимого внешней пямяти на АЦП
start: 
	lCALL	DELAY
	CLR	A
	mov	DPL,R1
	mov	DPH,R2
	mov	DPP,R3
	mov	R1,DPL
	mov	R2,DPH
	mov	R3,DPP
     	MOVX	A,@DPTR	
	mov DPP,#08h
	MOV DPTR,#0007H
	

	        movX @DPTR,A
	lcall PAUSE  
	lcall PAUSE 

	CJNE	R1,#11111111B,CR1
	
	CJNE	R2,#11111111B,CR2

	CJNE	R3,#00000001B,CR3
		
	ljmp	kon
PAUSE::                             	
        PUSH	PSW
	SETB	RS0   			
       	CLR	RS1



        MOV	R5,#4CH			
MP1::
        MOV	R4,#4CH
MP2::
        DJNZ	R4,MP2
        DJNZ	R5,MP1

        POP	PSW
        RET	


;===================задержка 5с====================================
DELAY:					
	MOV	R5,#400		
DLY0:	MOV	R6,#05Bh	
DLY1:	MOV	R7,#0FFh	
	DJNZ	R7,$		
	DJNZ	R6,DLY1         
	DJNZ	R5,DLY0		
	RET			
	
kon:
.END
