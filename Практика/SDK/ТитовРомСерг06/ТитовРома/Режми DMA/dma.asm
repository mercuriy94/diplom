#include define.asm

                                                  ; ������
CSEG
.ORG 0000h
        lJMP	MAIN            ; ������� � ������� ���������
	   	
;====================================================================
                                                       ; �������� ���������
.ORG 004Bh
MAIN:

; �������� ������� ������.

	MOV	ADCOFSH,#20h	; ��������� ������������� ����������
	MOV	ADCOFSL,#00h
	MOV	ADCGAINH,#20h
	MOV	ADCGAINL,#00h
	

	MOV	ADCCON1,#00h                                   ;������� ��� � �������� �����
	MOV     DPL,#00H    ; ��������� ��������� DPTR �� ������� ����� 
	MOV     DPH,#00H    ;
	MOV     DPP,#00H    ; 


	MOV	DMAL,#0
	MOV	DMAH,#0
	MOV	DMAP,#0


SETUP:	
	mov	R1,#03h        ; ������� ��� �������� �����

CICLE:
	MOV     A,#080h      		; ����� ������ �������������� �������
        	MOVX    @DPTR,A       	;������ �������������� ������ � ������� ������ ������ ������ 
        	INC     DPTR		;������� � ��������� ������
	CLR     A              		 ; ��������� ����� 
       	 MOVX    @DPTR,A		; ��������� ������ ������ - ����� ������� ��������� ��������������
        	INC     DPTR

        	DEC	R1		; ��������� �����
	CJNE	R1,#00h,CICLE	; �������, ���� ���� �� ��������
	mov	R1,00h

        MOV     A,#080h     		 ; ������ ����������� ������.
        MOVX    @DPTR,A         		; ��� �������� ������� "���� ���"
        INC     DPTR
        CLR     A
        MOVX    @DPTR,A
        INC     DPTR

        MOV     A,#0F0h         		; ������� "���� ���"
        MOVX    @DPTR,A

;������������ ��� ��������������


	MOV     ADCCON1,#0ACh   
	SETB	CCONV
	SETB	DMA

;        lJMP     MAIN

	JNB	ADCI,$
	CLR	ADCI	

	mov	R1,#00h
	mov	R2,#00h
	mov	R3,#00h

	ljmp	start

CR1:	inc	R1
        	ljmp	start

CR2:	inc	R2
	ljmp	start


CR3:	inc	R3
	ljmp	start

; ��������� ������ ����������� ������� ������ �� ���
start: 
	lCALL	DELAY
	CLR	A
	mov	DPL,R1
	mov	DPH,R2
	mov	DPP,R3
	mov	R1,DPL
	mov	R2,DPH
	mov	R3,DPP
     	MOVX	A,@DPTR	
	mov DPP,#08h
	MOV DPTR,#0007H
	

	        movX @DPTR,A
	lcall PAUSE  
	lcall PAUSE 

	CJNE	R1,#11111111B,CR1
	
	CJNE	R2,#11111111B,CR2

	CJNE	R3,#00000001B,CR3
		
	ljmp	kon
PAUSE::                             	
        PUSH	PSW
	SETB	RS0   			
       	CLR	RS1



        MOV	R5,#4CH			
MP1::
        MOV	R4,#4CH
MP2::
        DJNZ	R4,MP2
        DJNZ	R5,MP1

        POP	PSW
        RET	


;===================�������� 5�====================================
DELAY:					
	MOV	R5,#400		
DLY0:	MOV	R6,#05Bh	
DLY1:	MOV	R7,#0FFh	
	DJNZ	R7,$		
	DJNZ	R6,DLY1         
	DJNZ	R5,DLY0		
	RET			
	
kon:
.END
