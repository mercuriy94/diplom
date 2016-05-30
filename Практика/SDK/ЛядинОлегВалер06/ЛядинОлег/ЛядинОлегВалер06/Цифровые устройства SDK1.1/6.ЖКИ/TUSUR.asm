#INCLUDE	"DEFINE.ASM"


start::
	mov DPP,#08h
SVETODIOD::

;Движение курсора!!!

	MOV DPTR,#0006H
	MOV A,#08H         ;Запись команды
	movX @DPTR,A
	
	MOV A,#09H         ;Разрешить
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#1cH         ;Код команды смещения курсора
	movX @DPTR,A
	lcall PAUSE 

;Выод на экран символов
;Вывод Буквы "L" на ОПРЕДЕЛЁННУЮ позицию ЖКИ!

	MOV DPTR,#0006H
	MOV A,#08H         ;Запись команды
	movX @DPTR,A
	
	MOV A,#09H          ;Разрешить
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#82H          ;Определяем координаты символа
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;Запись данных
	movX @DPTR,A
	
	MOV A,#0DH         ;Разрешить
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#4CH         ;Код Буквы "L"
	movX @DPTR,A
	lcall PAUSE 

;Вывод Буквы "Е" на следующую позицию ЖКИ!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#83H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#45H
	movX @DPTR,A
	lcall PAUSE 

;Вывод Буквы "R" на следующую позицию ЖКИ!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#84H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#52H
	movX @DPTR,A
	lcall PAUSE  

;Вывод Буквы "А" на следующую позицию ЖКИ!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#85H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#41H
	movX @DPTR,A

;Конец вывода букв

	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE 

	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE

	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE 
	lcall PAUSE	

	
	ljmp SVETODIOD


PAUSE::                             	
        PUSH	PSW
	SETB	RS0   			
       	CLR	RS1



        MOV	R1,#9CH			
MP1::
        MOV	R0,#92H
MP2::
        DJNZ	R0,MP2
        DJNZ	R1,MP1

        POP	PSW
        RET	

	.END
	
