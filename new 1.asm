#INCLUDE	"DEFINE.ASM"	; подключение таблицы имён и кодов SFR, ;применённых в программе	
AJMP MAIN            ; переход к метке MAIN
MAIN:

YRunUp:
;Проверка предыдущего направления
	CJNE R2,#11000100b, motionSettingYUp
;Установка dir и step в высокий уровень
	mov A,#11000000b 
	movx @DPTR,A  
;Пауза в течении T0
	lcall pauseT0

;Установка dir в высокий уровень, а step в низкий
	mov A,#11001000b 
	movx @DPTR,A  
;Пауза в течении T0
	lcall pauseT0
	
;Установка step в высокий уровень, а dir в низкий
	mov A,#11000100b 
	movx @DPTR,A  
;Пауза в течении T1
	lcall pauseT1
	mov R2,A
	ljmp YRunUpReturn
motionSettingYUp:
	mov A,#11000100b 
	movx @DPTR,A  
;Пауза в течении T0
	lcall pauseT0
	mov R2,A
	ljmp YRunUp
YRunUpReturn
	ret
	



	;-----------------------------------------------------------------------------
initENA::			;подпрограмма инициализации порта ENA		
	mov DPP,#08h	;Выбор страницы ПЛИС
	mov DPTR,#0004H	;Выбор регистра в ПЛИС, предназначенного для настройки порта ENA
	mov A,#01h
	movx @DPTR,A	;Настройка порта на вывод данных, через байт EN_LO
	mov DPTR,#0002h ;Выбор регистра в ПЛИС EN_LO
	ret				;Возврат из подпрограммы
	
;-----------------------------------------------------------------------------	