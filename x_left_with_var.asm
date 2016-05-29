#INCLUDE	"DEFINE.ASM"  

.org 0000h
ValPauseT0H	.EQU	0001h
ValPauseT0L	.EQU	0002h
ValPauseT1H	.EQU	0003h
ValPauseT1L	.EQU	0004h
ValPauseT2H	.EQU	0005h
ValPauseT2L	.EQU	0006h

;загрузка значений в переменные
initVar:
	mov ValPauseT0H,#0FFh
	mov ValPauseT0L,#0ACh
	
	mov ValPauseT1H,#0FFh
	mov ValPauseT1L,#0ACh
	
	mov ValPauseT2H,#0FDh
	mov ValPauseT2L,#07Dh
main::

;настройка порта ENA
	lcall initENA ; Вызов подпрограммы инициалзиации порта ENA, настроенного на вывод данных
	
	
	mov R1,#0Eh
for0::
	cjne R1,#00h,run1
loop::
	ljmp loop	
run1::
	mov R0,#0F0h
for1::
	cjne R0,#00h,run
	dec R1
	ljmp for0

run::
	lcall XRunDown
	dec R0
	ljmp for1
loop1::
	ljmp loop1


		
;-----------------------------------------------------------------------------
initENA::			;подпрограмма инициализации порта ENA		
	mov DPP,#08h	;Выбор страницы ПЛИС
	mov DPTR,#0004H	;Выбор регистра в ПЛИС, предназначенного для настройки порта ENA
	mov A,#01h
	movx @DPTR,A	;Настройка порта на вывод данных, через байт EN_LO
	mov DPTR,#0002h ;Выбор регистра в ПЛИС EN_LO
	ret				;Возврат из подпрограммы
	
;-----------------------------------------------------------------------------	

XRunUp:
;Проверка предыдущего направления
	CJNE R2,#11000001b, motionSettingXUp
;Установка dir и step в высокий уровень
	mov A,#11000000b 
	movx @DPTR,A  
;Пауза в течении T0 
	lcall pauseT0	
;Установка dir в высокий уровень, а step в низкий
	mov A,#11000010b 
	movx @DPTR,A  
;Пауза в течении T1
	lcall pauseT1
;Установка step в высокий уровень, а dir в низкий
	mov A,#11000001b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp XRunUpReturn
	
motionSettingXUp:
;Установка step в высокий уровень, а dir в низкий
	mov A,#11000001b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp XRunUp
XRunUpReturn
	ret
	
	
	
	
	
XRunDown:
;Проверка предыдущего направления
	CJNE R2,#11000000b, motionSettingXDown
;Установка dir в низкий уровень, а step в высокий
	mov A,#11000001b 
	movx @DPTR,A  
;Пауза в течении T0
	lcall pauseT0
;Установка step в низкий уровень, и dir в низкий
	mov A,#11000011b 
	movx @DPTR,A  
;Пауза в течении T1
	lcall pauseT1
;Установка dir и step в высокий уровень
	mov A,#11000000b
	movx @DPTR,A
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp XRunDownReturn
motionSettingXDown:
	mov A,#11000000b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp XRunDown
XRunDownReturn:
	ret

		;Пауза T0 = 40 мкс
pauseT0::
	mov TH2,ValPauseT0H;== только для первого цикла счетчика
	mov TL2,ValPauseT0L;
	setb TR2;== запустить счетчик-таймер2
WAIT0:
	JNB TF2,WAIT0		;ожидание переполнения счетчика
	CLR TF2			;сброс флага переполнения
	clr TR2
	ret

;-----------------------------------------------------------------------------
	;Пауза T1 = 40 мкс
pauseT1::
	mov TH2,ValPauseT1H;== только для первого цикла счетчика
	mov TL2,ValPauseT1L;
	setb TR2;== запустить счетчик-таймер2
WAIT1:
	JNB TF2,WAIT1		;ожидание переполнения счетчика
	CLR TF2			;сброс флага переполнения
	clr TR2
	ret
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
	;Пауза T2 = 500 мкс
pauseT2:
	mov TH2,ValPauseT2H;== только для первого цикла счетчика
	mov TL2,ValPauseT2L;
	setb TR2;== запустить счетчик-таймер2
WAIT2:
	JNB TF2,WAIT2		;ожидание переполнения счетчика
	CLR TF2			;сброс флага переполнения
	clr TR2
	ret
;-----------------------------------------------------------------------------

.end

