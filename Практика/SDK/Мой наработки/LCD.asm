#INCLUDE	"DEFINE.ASM" ; подключение таблицы имён и кодов SFR, ;применённых в программе	
start:
	mov DPP,#08h ;настройка страницы ПЛИС
main:
;----------------включение экрвна с высвечиванием и без мерцания символа-------------
	
	MOV DPTR,#0001H	;выбор регистра данных DATA_IND
	mov A,#0Eh	;запись данных в аккумулятор
	movx @DPTR,A ;Записываем данные из аккумулятора  в быранный регистр ПЛИСа
	
	MOV DPTR,#0006H    ;выбор регистра команд C_IND
	mov A,#01h          ;RS=0,RW=0,E=1:запись в аккумулятор данных
	movx @DPTR,A		 ;Запись данных в из аккумулятора в  регистр команд
	
	mov A,#00h  
	movx @DPTR,A		;RS=0,RW=0,E=0   стираем данные из регистра команд
	lcall Pause			;ставим паузу в размере 2 секунды

	
;----------------------------высвечивание символа 1 в 4 позиции------------------------
			;-------------------------------------------------------------------------------
	MOV DPTR,#0001H	 ;выбор регистра данных DATA_IND
	mov A,#31h			 ;запись данных в аккумулятор
	movx @DPTR,A		 ;Записываем данные из аккумулятора  в быранный регистр ПЛИСа
	
	MOV DPTR,#0006H  ;выбор регистра команд C_IND
	mov A,#05h         ;запись в аккумулятор данных
	movx @DPTR,A		;Запись данных в из аккумулятора в  регистр команд(RS=1,RW=0,E=1 )
	
	mov A,#04h  		;RS=1,RW=0,E=0   стираем данные из регистра команд
	movx @DPTR,A		;RS=0,RW=0,E=0  
	lcall Pause			 ;ставим паузу в размере 2 секунды
	
;----------------------высвечивание символа 2 во 2-ой позиции---------------------------------
;все пречисленные ниже действия идентичный действию высвечиния 1 в позиции 1 , за исключением
;выбора позиции в видеопамяти и выбора элемента в знакогенераторе

			;-------------------------------------------------------------------------------
	MOV DPTR,#0001H	 
	mov A,#32h
	movx @DPTR,A
	
	MOV DPTR,#0006H
	mov A,#05h         
	movx @DPTR,A
	
	mov A,#04h  
	movx @DPTR,A		
	lcall Pause
	
;-------------------------------------------------------------------------------
MP:
	ljmp MP
;-------------------------------------------------------------------------------

;функция паузы
Pause:
	MOV TCON,#00H	;настройка регистра управления таймером в
			;состояние по умолчанию, при этом снимаются 
			;ранее установленные флаги переполнения и 
			;останавливается счет событий.
	MOV TMOD,#00110001b	;загрузка регистра TMOD - таймер 0 
		;настраивается как 16-разрядный счетчик с 
	mov TH0,#00h;== только для первого цикла счетчика
	mov TL0,#00h;
	SETB TR0			;запуск счета событий
	mov R3,#64d;== 32 интервалов по 0.03125сек ~ 1сек
WAIT:
	JNB TF0,WAIT		;ожидание переполнения счетчика
	CLR TF0			;сброс флага переполнения
	djnz R3,WAIT
	mov R3,#64d;== 32 интервалов по 0.03125сек ~ 1сек
	clr TR0
	ret
	.end

