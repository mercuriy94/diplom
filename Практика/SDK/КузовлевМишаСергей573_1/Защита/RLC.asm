#INCLUDE	"DEFINE.ASM"   		; Подключение таблицы sfr-регистров.
	.ORG	0h
	ljmp	START
	.ORG	23h
	ljmp	UART_int
	.ORG	100h

;+++++++++++++++++ Начало программы ++++++++++++++++++++++++++++++++
START::
	MOV	PLLCON,#51h	; Частота процессора 16,77 / 2 = 8,38МГц
	MOV	T3CON,#85h		; Настройка скорости COM-порта через таймер 3 	
	MOV	T3FD,#2Dh		; Скорость передачи данный 9600 бод
	MOV	SCON,#50h		; UART (COM-порт)
	MOV	DPP,#08h		; Установка стран. памяти для доступа к регистрам ПЛИC.
	MOV 	DPTR,#0007H	; Выбор регистра управления светодиодами.
	LCALL	PAUSE 	; Вызов подпрограммы паузы.
	MOV	A,#011H		; Занесение данных "00" в аккумулятор А.
	MOVX	@DPTR,A
	SETB	ES
	SETB	EA
LOOP_PROG:
	LJMP	LOOP_PROG
;+++++++++++++++++ Прерывание СОМ-порта ++++++++++++++++++++++++++++
UART_int:
	CLR 	ES
	CLR	RI
	CLR	TI
	MOV	R3,SBUF		;Заносим значение частоты дискретизации
	MOV	A,R3
	CJNE	A,#0C3h,INT_END	; значит пришла команда подключения
	LCALL	VOZV1
	MOV	A,#0FEh	
	MOV	SBUF,A
	JNB	TI,$			; Дождаться таймер
	CLR	TI
	MOV	A,#0FEh	
	MOV	SBUF,A
	JNB	TI,$			; Дождаться таймер
	CLR	TI

INT_END:
	CJNE	A,#0C4h,END1
	MOV	A,#0C4h
	MOV	SBUF,A
	JNB	TI,$			; Дождаться таймер
	CLR	TI
	MOV	A,#0C4h
	MOV	SBUF,A
	JNB	TI,$			; Дождаться таймер
	CLR	TI
END1:
	MOV	DPP,#08h		; Установка стран. памяти для доступа к регистрам ПЛИC.
	MOV 	DPTR,#0007H	; Выбор регистра управления светодиодами.
	LCALL	PAUSE 	; Вызов подпрограммы паузы.
	MOV	A,#022H		; Занесение данных "00" в аккумулятор А.
	MOVX 	@DPTR,A
	SETB	ES
	RETI
;+++++++++++++++++ Конец прерывания ++++++++++++++++++++++++++++++++++

;+++++++++++++++++ Настройка ЦАП0 ++++++++++++++++++++++++++++++++++++
VOZV1: 

	MOV	DACCON,#00001101B; Режим работы ЦАП0 12бит, асинхронный режим
	MOV	DAC0H,#000h	; Установка начального уровня сигнала
	MOV	DAC0L,#000h	; 
	MOV	R5,#00H		; регистр DPH
	MOV	R6,#00H		; регистр DPL
VOZV:
	MOV	ADCCON1,#10001100B; Установка АЦП в нормальный ;режима с внутренним ИОНом
	MOV	DPTR,#TABLE
	MOV	R2,#00H		; счетчик циклов синусоиды 64 (40H)
STEP: 
	CLR	A			; Очистить аккумулятор
	MOVC	A,@A+DPTR	; Загрузить данные в аккумулятор из таблицы синуса
	MOV	DAC0H,A		; Загрузить данные в старший регистр ЦАП
	INC	DPTR			; Переход на следующий адрес в таблице
	CLR	A			; Очистить аккумулятор
	MOVC	A,@A+DPTR	; Загрузить данные в аккумулятор из таблицы синуса
	MOV	DAC0L,A		; Загрузить данные в младший регистр ЦАП
	INC	DPTR			; Переход на следующий адрес в таблице
	INC	R4			; Инкремент регистра выбора канала АЦП
	LCALL	PAUSE
	INC	R2
	nop

	CJNE	R4,#001h,ADC1
	MOV	ADCCON2,#00000001B; Установка нулевого канала	
	LCALL	ADC
	MOV	ADCCON2,#00000000B; Установка нулевого канала
	SJMP	DDD
ADC1:
	MOV	R4,#00H
	MOV	ADCCON2,#00000000B; Установка нулевого канала
	LCALL	ADC
	MOV	ADCCON2,#00000000B; Установка нулевого канала
DDD:
	CJNE	R5,#008h,NOPER
	SJMP	DIOD
NOPER:	
	CJNE	R2,#040h,STEP1	; Наступил ли конец таблицы синуса? переходы по условиям 
	LJMP	VOZV			; Переход по метке.
STEP1:
	LJMP 	STEP
;+++++++++++++++++++++++++++   Чтение из памяти в ПК  ++++++++++++++++
DIOD:
	MOV	DPP,#08h		; Установка страницы памяти для доступа к регистрам ПЛИC.       
	MOV 	DPTR,#0007H	; Выбор регистра управления светодиодами.
	LCALL	PAUSE 	; Вызов подпрограммы паузы.
	MOV 	A,#0DDH		; Занесение данных "00" в аккумулятор А.
	MOVX	@DPTR,A
	MOV	DPP,#00h
	MOV	DPTR,#0000H	
PERED:
	MOVX	A,@DPTR
	INC	DPTR
	MOV	SBUF,A
	JNB	TI,$			; Дождаться таймер
	CLR	TI
	LCALL 	PAUSE
	MOV	A,DPH
	MOV	R5,A
	CJNE	R5,#008h,PERED
	MOV	DPP,#08h		; Установка страницы памяти для доступа к регистрам ПЛИC.
	MOV	DPTR,#0007H	; Выбор регистра управления светодиодами.
	LCALL	PAUSE 	; Вызов подпрограммы паузы.
	MOV	A,#0FFH		; Занесение данных "00" в аккумулятор А.
	MOVX	@DPTR,A
	MOV	R3,#00h
	RET
;++++++++++++++++ запись в память из АЦП1 +++++++++++++++++++++++++++
ADC:	
	PUSH	DPL
	PUSH	DPH
	MOV	DPP,#00h
	MOV	A,R5
	MOV	DPH,A
	MOV	A,R6
	MOV	DPL,A
	MOV	ADCCON3,#00000000b
	SETB	SCONV 		; Инициализация однократного преобразования
	MOV	A,ADCDATAH 
	MOVX	@DPTR,A
	INC	DPTR
	MOV	A,ADCDATAL 
	MOVX	@DPTR,A
	INC	DPTR
	MOV	A,DPH
	MOV	R5,A
	MOV	A,DPL
	MOV	R6,A
	POP	DPH
	POP	DPL
	RET
;++++++++++++++++++++++++++   ПАУЗА (78 мкс)  ++++++++++++++++++++++++
					; R1-6 R2-22 = 200Гц
PAUSE:	
	PUSH	PSW			; Начало подпрограммы паузы.
	MOV	R1,#006H		; Занесение данных "CC" в регистр R1.
MP1:
	MOV	R0,#022H
MP2:
	DJNZ	R0,MP2		; Если значения регистра не 0, то переход по метке.
	DJNZ	R1,MP1
	POP	PSW
	RET				; Выход из подпрограммы.
;++++++++++++++++++++  Таблица синуса   ++++++++++++++++++++++++++++++
.ORG  01000H
TABLE:
.DB  007h, 0FFh
.DB  008h, 0C8h
.DB  009h, 08Eh
.DB  00Ah, 051h
.DB  00Bh, 00Fh
.DB  00Bh, 0C4h
.DB  00Ch, 071h
.DB  00Dh, 012h
.DB  00Dh, 0A7h
.DB  00Eh, 02Eh
.DB  00Eh, 0A5h
.DB  00Fh, 00Dh
.DB  00Fh, 063h
.DB  00Fh, 0A6h
.DB  00Fh, 0D7h
.DB  00Fh, 0F5h
.DB  00Fh, 0FFh
.DB  00Fh, 0F5h
.DB  00Fh, 0D7h
.DB  00Fh, 0A6h
.DB  00Fh, 063h
.DB  00Fh, 00Dh
.DB  00Eh, 0A5h
.DB  00Eh, 02Eh
.DB  00Dh, 0A7h
.DB  00Dh, 012h
.DB  00Ch, 071h
.DB  00Bh, 0C4h
.DB  00Bh, 00Fh
.DB  00Ah, 051h
.DB  009h, 08Eh
.DB  008h, 0C8h
.DB  007h, 0FFh
.DB  007h, 036h
.DB  006h, 070h
.DB  005h, 0ADh
.DB  004h, 0EFh
.DB  004h, 03Ah
.DB  003h, 08Dh
.DB  002h, 0ECh
.DB  002h, 057h
.DB  001h, 0D0h
.DB  001h, 059h
.DB  000h, 0F1h
.DB  000h, 09Bh
.DB  000h, 058h
.DB  000h, 027h
.DB  000h, 009h
.DB  000h, 000h
.DB  000h, 009h
.DB  000h, 027h
.DB  000h, 058h
.DB  000h, 09Bh
.DB  000h, 0F1h
.DB  001h, 059h
.DB  001h, 0D0h
.DB  002h, 057h
.DB  002h, 0ECh
.DB  003h, 08Dh
.DB  004h, 03Ah
.DB  004h, 0EFh
.DB  005h, 0ADh
.DB  006h, 070h
.DB  007h, 036h          
;+++++++++++++++++++++++++++++++   конец таблицы   ++++++++++++++++++
.end				; Конец программы.
