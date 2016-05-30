#INCLUDE	"DEFINE.ASM"   

START:		
	mov DPP,#08h
	mov DPTR,#0004H
	mov A,#02h
	movX @DPTR,A	
loop	
	mov DPTR,#0002H
	movX A,@DPTR
	
	mov DPTR,#0003H
	movX @DPTR,A


	sjmp loop
	.end
	
