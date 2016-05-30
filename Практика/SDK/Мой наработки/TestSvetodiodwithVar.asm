#INCLUDE	"DEFINE.ASM"	; подключение таблицы имён и кодов SFR, ;применённых в программе
value	.EQU	0000H

setup:
 mov DPP,#08h				
 mov DPTR,#0007H	

main:
	mov A,#ffh
	movX @DPTR,A
	
loop:
	ljmp loop

.end
