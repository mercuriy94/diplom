#include define.asm

CSEG
.ORG 0000h
	lJMP MAIN            ; переход к главной программе
; программа

.ORG 004Bh

MAIN:
 
	MOV	EADRL,#0		;выбрать страницу 0 Flash/EE ;памяти данных
	MOV 	ECON,#1		;чтение страницы 0
	MOV	EDATA1,ADCOFSL	 ;создание образа 
	MOV	EDATA2,ADCOFSH 	; коэффициентов в 	;EDATA1,2,3,4
	MOV	EDATA3,ADCGAINL
	MOV	EDATA4,ADCGAINH
	MOV	ECON,#5		; очистка страницы 0
	MOV	ECON,#2		; запись ;коэффициентов в ;EDATA1,2,3,4 на  
; страницу 0 Flash/EE памяти 
	
;Следующий код производит копирование данных калибровки в 
;соответствующие регистры.
	MOV	EADRL,#0		;выбрать страницу 0 ;Flash/EE ;памяти ;данных
	MOV 	ECON,#1		;чтение страницы 0
	MOV	ADCOFSL, EDATA1	 ;восстановление ;коэффициентов  
	MOV	ADCOFSH, EDATA2 	; ;калибровки из ;EDATA1,2,3,4
	MOV	ADCGAINL, EDATA3
	MOV	ADCGAINH, EDATA4
.END
.END