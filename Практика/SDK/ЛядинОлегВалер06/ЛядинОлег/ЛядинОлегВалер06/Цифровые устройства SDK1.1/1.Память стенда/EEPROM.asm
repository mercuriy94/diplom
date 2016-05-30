#INCLUDE	"DEFINE.ASM"
	.ORG 0000h
	AJMP MAIN            ; jump to main program

	.ORG 004Bh

MAIN:
	mov A,#01h
	MOV ECON,#06h 
; Запись данных во второй байт 03 - страницы
;1.
	MOV EADRH,#00H
	MOV EADRL,#06H
;2. 
	MOV ECON,#01h ; 	Чтение EDATA1-4
	MOV EDATA1,#088H ;  	Перезапись второго байта
;3. 
	MOV ECON,#05h ;  	Стереть страницу
	MOV ECON,#02h ; 	Запись страницы
	MOV ECON,#04h 
	MOV ECON,#04h ; Проверка записи
	MOV A,ECON ; Если результат "0" то всё OK!



; Чтение данных из второго байта 03 - страницы
;1.
	MOV EADRH,#00H
	MOV EADRL,#06H
;2. 
	MOV ECON,#01h ; 	Чтение EDATA1-4
;3. 
	MOV A,EDATA1
	MOV ECON,#04h 

; вывод результата на светодиоды
	mov DPP,#08h
	MOV DPTR,#0007H
	movX @DPTR,A	
start::

	LCALL DELAY5
	LCALL start


;задержка
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