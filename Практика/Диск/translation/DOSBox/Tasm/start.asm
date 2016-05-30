#INCLUDE	"DEFINE.ASM"     ; подключение таблицы имён и кодов SFR, ;применённых в программе

START:		
	mov DPP,#08h		;выбор страницы ргеистра ПЛИС
	mov DPTR,#0004H		;выбор регистра ENA
	mov A,#02h			
	movX @DPTR,A		;
loop	
	mov DPTR,#0002H
	movX A,@DPTR
	
	mov DPTR,#0003H
	movX @DPTR,A


	sjmp loop
	.end
	