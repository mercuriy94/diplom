#INCLUDE	"DEFINE.ASM"  

;mov A,#11000010b 
;movx @DPTR,A  

main:
	lcall initENA ; Вызов подпрограммы инициалзиации порта ENA, настроенного на вывод данных
	mov A,#00000000b 
	movx @DPTR,A  
loop:
	ljmp loop;

initENA::			;подпрограмма инициализации порта ENA		
	mov DPP,#08h	;Выбор страницы ПЛИС
	mov DPTR,#0004H	;Выбор регистра в ПЛИС, предназначенного для настройки порта ENA
	mov A,#01h
	movx @DPTR,A	;Настройка порта на вывод данных, через байт EN_LO
	mov DPTR,#0002h ;Выбор регистра в ПЛИС EN_LO
	ret				;Возврат из подпрограммы

 .end
 
 