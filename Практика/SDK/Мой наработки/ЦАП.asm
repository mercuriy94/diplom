#INCLUDE	"DEFINE.ASM"   

START:		
	MOV		DAC0H,#0fh ; старшие биты
	MOV		DAC0L,#0ffh ; младшие биты
	mov DACCON,#00101101b
	sjmp START
	.end
	
	
