#INCLUDE	"DEFINE.ASM"	; подключение таблицы имён и кодов SFR
;Подключение переменных используемых в программе

ValPauseT0H	.EQU	0FFh
ValPauseT0L	.EQU	0ACh
ValPauseT1H	.EQU	0FFh
ValPauseT1L	.EQU	0ACh
ValPauseT2H	.EQU	0FBh
ValPauseT2L	.EQU	0E6h
	
;загрузка значений в переменные
;initVar:
	;mov ValPauseT0H,#0FFh
	;mov ValPauseT0L,#0ACh ;70
	
	;mov ValPauseT1H,#0FFh
	;mov ValPauseT1L,#0ACh
	
	;mov ValPauseT2H,#0FBh
	;mov ValPauseT2L,#0E6h ;700
	;lJMP MAIN            ; переход к метке MAIN
MAIN:
	mov R1,#00h
	
readKey4: ;проверка нажатия на клавишу  -4
	mov R0,#0eh  ;превый столбец
	lcall readKey
	CJNE A,#0deh,readKey7 ;Проверка нажатия кнопки - 4 
	MOV R1,#04h
	ljmp handler_result
readKey7: ;проверка нажатия на клавишу  -7
	mov R0,#0eh  ;превый столбец
	lcall readKey
	CJNE A,#0beh,readKey2 ;Проверка нажатия кнопки - 7 
	MOV R1,#07h
	ljmp handler_result
readKey2:	;проверка нажатия на клавишу  -2
	mov R0,#0dh		;второй столбец
	lcall readKey
	CJNE A,#0edh,readKey8 ;Проверка нажатия кнопки - 2 
	MOV R1,#02h
	ljmp handler_result
readKey8:	;проверка нажатия на клавишу  -8
	mov R0,#0dh		;второй столбец
	lcall readKey
	CJNE A,#0bdh,readKey3 ;Проверка нажатия кнопки - 8 
	MOV R1,#08h
	ljmp handler_result	
readKey3:	;проверка нажатия на клавишу  -3
	mov R0,#0bh		;второй столбец
	lcall readKey
	CJNE A,#0ebh,readKey6 ;Проверка нажатия кнопки - 3 
		MOV R1,#03h
	ljmp handler_result
readKey6:	;проверка нажатия на клавишу  -6
	mov R0,#0bh		;второй столбец
	lcall readKey
	CJNE A,#0dbh,handler_result ;Проверка нажатия кнопки - 6 

	MOV R1,#06h
	ljmp handler_result
handler_result:
; вывод результата на светодиоды
	MOV DPTR,#0007H
	mov A,R1
	movX @DPTR,A
	lcall motionTransmission
	ljmp MAIN


;-----------------------------------------------------------------------------	
	;up - left
	;down - right
motionTransmission:
	lcall initENA
XUp:
	CJNE R1,#04h, XDown
	lcall XRunUp
	lcall return
XDown:
	CJNE R1,#06h, YUp
	lcall XRunDown
	lcall return
YUp:
	CJNE R1,#03h, YDown
	lcall YRunUp
	lcall return
YDown:
	CJNE R1,#07h, ZUp
	lcall YRunDown
	lcall return
ZUp:
	CJNE R1,#02h, ZDown
	lcall ZRunUp
	lcall return
ZDown:
	CJNE R1,#08h, return
	lcall ZRunDown
	lcall return
return:	
	ret
	
;-----------------------------------------------------------------------------
readKey: ;Метод считывания клавиш ()
	mov DPP,#08h		;выбор страницы ргеистра ПЛИС
	MOV DPTR,#0000H	  ;ригистр клавиатуры
	MOV A,R0
	movX @DPTR,A
	movX A,@DPTR
	ret
;-----------------------------------------------------------------------------	

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
;-----------------------------------------------------------------------------




;-----------------------------------------------------------------------------	

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
;Пауза в течении 1
	lcall pauseT1
;Установка step в высокий уровень, а dir в низкий
	mov A,#11000100b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp YRunUpReturn
motionSettingYUp:
	mov A,#11000100b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp YRunUp
YRunUpReturn
	ret
	
	
	
	
	
YRunDown:
;Проверка предыдущего направления
	CJNE R2,#11000000b, motionSettingYDown
;Установка dir в низкий , а step в высокий
	mov A,#11000100b 
	movx @DPTR,A  
;Пауза в течении T0
	lcall pauseT0
;Установка dir и step в низкий уровень
	mov A,#11001100b 
	movx @DPTR,A  
;Пауза в течении T1
	lcall pauseT1
;Установка dir и step в высокий уровень
	mov A,#11000000b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A ;Запись последнего движения
	ljmp YRunDownReturn
motionSettingYDown:
	mov A,#11000000b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp YRunDown
YRunDownReturn:
	ret

;-----------------------------------------------------------------------------


;-----------------------------------------------------------------------------	

ZRunUp:
;Проверка предыдущего направления
	CJNE R2,#11010000b, motionSettingZUp
;Установка dir и step в высокий уровень
	mov A,#11000000b 
	movx @DPTR,A  
;Пауза в течении T0
	lcall pauseT0
;Установка dir в высокий уровень, а step в низкий
	mov A,#11100000b 
	movx @DPTR,A  
;Пауза в течении T1
	lcall pauseT1
;Установка step в высокий уровень, а dir в низкий
	mov A,#11010000b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp ZRunUpReturn
motionSettingZUp:
	mov A,#11010000b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp ZRunUp
ZRunUpReturn
	ret
	
	
	
	
	
ZRunDown:
;Проверка предыдущего направления
	CJNE R2,#11000000b, motionSettingZDown
;Установка dir в низкий , а step в высокий
	mov A,#11010000b 
	movx @DPTR,A  
;Пауза в течении T0
	lcall pauseT0
;Установка dir и step в низкий уровень
	mov A,#11110000b 
	movx @DPTR,A  
;Пауза в течении T1
	lcall pauseT1
;Установка dir и step в высокий уровень
	mov A,#11000000b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A ;Запись последнего движения
	ljmp ZRunDownReturn
motionSettingZDown:
	mov A,#11000000b 
	movx @DPTR,A  
;Пауза в течении T2
	lcall pauseT2
	mov R2,A
	ljmp ZRunDown

ZRunDownReturn:
	ret

;-----------------------------------------------------------------------------




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

