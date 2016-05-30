#INCLUDE	"DEFINE.ASM"


start::

	mov DPP,#08h
	MOV DPTR,#0004H

	
SVETODIOD::

	
	MOV A,#10H
	movX @DPTR,A
	lcall PAUSE  
	MOV A,#00H
	movX @DPTR,A
	lcall PAUSE 
	ljmp SVETODIOD


PAUSE::                             	
        PUSH	PSW
	SETB	RS0   			
       	CLR	RS1
        MOV	R1,#01fH			
MP1::
        MOV	R0,#0aH
MP2::
        DJNZ	R0,MP2
        DJNZ	R1,MP1
        POP	PSW
        RET	

	.END
