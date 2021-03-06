#INCLUDE	"DEFINE.ASM" 
.org 0000h
	ljmp START
	
.ORG 2003h;== с этого адреса переход к подпрограмме обработчику прерывания
	ljmp int0;== по переполнению от "таймера 2" - T2_int 

START:
	mov DPP,#08h	
    mov DPTR,#0007H	
	mov A,#00h
	mov R3,#08d;== 200 интервалов по 0.005сек = 1сек
	movX @DPTR,A  ;Записываем занчение аккумулятора во внешнюю память
	lcall Init_Int
	ljmp mp
mp:
	sjmp mp
	
Init_Int:
	MOV TCON,#01H	;настройка регистра управления таймером в
			;состояние по умолчанию, при этом снимаются 
			;ранее установленные флаги переполнения и 
			;останавливается счет событий.
	MOV TMOD,#00110001b	;загрузка регистра TMOD - таймер 0  
						;настраивается как 16-разрядный счетчик с 
	mov TH0,#00h;== только для первого цикла счетчика
	mov TL0,#00h;
	
	setb EA;== снять запрет со ВСЕХ прерываний
	setb EX0; Записывается пользователем для того, чтобы разрешить («1») или запретить («0») внешнее прерывание 0.
	ret
	
int0:
	
	clr EX0
	xrl A,#0ffh
	movX @DPTR,A  ;Записываем занчение аккумулятора во внешнюю память
	lcall Pause
	
	setb EX0
	reti
	
Pause:
	SETB TR0			;запуск счета событий
WAIT:
	JNB TF0,WAIT		;ожидание переполнения счетчика
	CLR TF0			;сброс флага переполнения
	djnz R3,WAIT
	mov R3,#08d;== 200 интервалов по 0.005сек = 1сек
	clr TR0
	ret
	.end

	