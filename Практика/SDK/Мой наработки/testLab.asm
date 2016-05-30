#INCLUDE	"DEFINE.ASM"  
.ORG 000bh


START: 



Handler_T0:
	RETI
loop:
	ljmp loop
.end

