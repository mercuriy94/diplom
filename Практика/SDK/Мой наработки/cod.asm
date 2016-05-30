#INCLUDE	"DEFINE.ASM"
	ljmp START
.ORG 200bh;== с этого адреса переход к подпрограмме обработчику прерывания
	ljmp INT_Timer0;== по переполнению от "таймера 2" - T2_int 
.ORG 2100h 
START:
	mov PLLCON,#54h ;настройка процессора на частоту 1.048576 МГц
	lcall initENA 	;вызов инициализации ENA
	mov DPTR,#0002H   ;насройка  адреса регистра данных EXT_LO
	movX A,@DPTR		;запись данных в аккумулятор из регистра EXT_LO
	cjne A,#71h,errorX1 ;провера ссоотвествия числа X1
	mov A,#01h
	mov DPTR,#0003H		;настройка регистра EXT_HI
	movX @DPTR,A		;вывод на светодиоды
	
	mov R0,#160d	;установка количества циклов переполнения таймера
	MOV TCON,#00H	;загрузка регистров таймера 0 
	MOV TMOD,#01b	;(При частоте генератора 1.048575 МГЦ, время инкремента ~ 1мкс)	
	mov TH0,#00h
	mov TL0,#00h
	setb ET0;== разрешить прерывания от событий таймера0
	setb EA;== снять запрет со ВСЕХ прерываний
	setb TR0;== запустить счетчик-таймер0
mp1:
	cjne R0,#00,mp1
	mov DPTR,#0002H   ;выбор регистра данных EXT_LO
	movX A,@DPTR		;запись данных в аккумулятор из регистра EXT_LO
	cjne A,#11h,errorX2  ;проверка состояние Х2
	mov DPTR,#0003H	;выбор регистра EXT_HI
	movX @DPTR,A	;вывод Х1 на светодиоды
	
	mov R0,#80d		;установка количества переполнения таймера
	MOV TCON,#00H
	MOV TMOD,#01b	;загрузка регистра TMOD - таймер 0 
	mov TH0,#00h
	mov TL0,#00h
	setb ET0;== разрешить прерывания от событий таймера0
	setb EA;== снять запрет со ВСЕХ прерываний
	setb TR0;== запустить счетчик-таймер0
mp2:
	cjne R0,#00h,mp2
	clr TR0
	clr ET0
	mov A,#80h
	mov DPTR,#0003H	;выбор регистра EXT_HI
	movX @DPTR,A		;запись данных из аккумулятора в регистр EXT_HI

main:
	
loop
	ljmp loop

initENA:	;настройка порта ENA 
	mov DPP,#08h	;выбор страницы регистра ПЛИС
	mov DPTR,#0004H	;выбор регистра ENA
	mov A,#02h			
	movX @DPTR,A	;задаём параметры, что бы появилась возможность считывать данные из EXT_LO и запись в EXT_HI
	ret

INT_Timer0: ;подпрограмма обработка прерывания таймера 0
	clr TF0
	clr TR0
	mov TH0,#00h
	mov TL0,#00h
	dec R0
	setb TR0
	RETI	

errorX2: ;подпрограмма при неправильном вводе во второй раз
	mov A,#20h
	mov DPTR,#0003H	;выбор регистра EXT_HI
	movX @DPTR,A	
	sjmp errorX2
	
errorX1: ;подпрограмма при не правильном вводе в первый раз
	mov A,#40h
	mov DPTR,#0003H		;выбор регистра EXT_HI
	movX @DPTR,A		;запись данных из аккумулятора в регистр EXT_HI
	sjmp errorX1
	
	
.end

