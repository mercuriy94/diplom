#INCLUDE	"DEFINE.ASM"


start::

	mov DPP,#08h
	MOV DPTR,#0007H
	MOV A,#01H	
	
SVETODIOD::

	INC A
	movX @DPTR,A
	lcall PAUSE  
	lcall PAUSE 
	ljmp SVETODIOD


PAUSE::                             	
        PUSH	PSW
	SETB	RS0   			
       	CLR	RS1



        MOV	R1,#4CH			
MP1::
        MOV	R0,#0F2H
MP2::
        DJNZ	R0,MP2
        DJNZ	R1,MP1

        POP	PSW
        RET	
		.END