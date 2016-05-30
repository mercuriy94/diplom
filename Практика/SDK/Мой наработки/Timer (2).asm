﻿#INCLUDE	"DEFINE.ASM"  
START: 
;инициализация светодиодов
		mov DPP,#08h				
      	  	mov DPTR,#0007H
		mov A,#0FFh
;инициализация таймера
		lcall Init_Timer2
;переход в функцию с бесконечным циклом
		ljmp main
;----------------------------------------
	.ORG 202bh;== с этого адреса переход к подпрограмме обработчику прерывания
	ljmp T2_int;== по переполнению от "таймера 2" - T2_int 

;----------------------------------------

;-----------------------------------------
main:
		movX @DPTR,A 	 
		ljmp main
;-----------------------------------------

Init_Timer2:
	mov R3,#32d;== 200 интервалов по 0.005сек = 1сек
	mov RCAP2H,#00h;== FC96 - дает интервал 0.005 сек.
	mov RCAP2L,#00h
	mov TH2,#00h;== только для первого цикла счетчика
	mov TL2,#00h;
	setb ET2;== разрешить прерывания от событий таймера2
	setb EA;== снять запрет со ВСЕХ прерываний
	setb TR2;== запустить счетчик-таймер2
	RET		;== возврат из подпрограммы

;------------------------------------------------

	;================================================
T2_int:
	clr TF2;== обязательный сброс флага переполнения TF2
	djnz R3,vyhod;== 200 интервалов (по 0.005сек = 1сек) прошло ?
	mov R3,#32d;== секунда прошла – в счетчик прерываний снова 200	
	
	xrl A,#0ffh
vyhod:
	RETI		;== возврат из подпрограммы обработчика прерывания
;================================================ 
;------------------------------------------------
MP:
		ljmp MP
		.end
