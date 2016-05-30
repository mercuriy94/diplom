#include define.asm
LED        .EQU	P3
CHAN    .EQU	1000B               ; ����� ������ ��� (0-8) � 10-��� �������
	                          ; 
;____________________________________________________________________
                                                  ; ������
CSEG

.ORG 0000h
		
	lJMP MAIN            ; jump to main program

; �����
.ORG 004Bh

MAIN:

; PRECONFIGURE...
    	MOV     T3CON,#83h	; ��������� ������ 	
	MOV     T3FD,#02Dh		; � ����
	MOV     SCON,#52h		; UART (COM-����)
	MOV     ADCCON1,#0ACh         ; ���������� �������� ���
	MOV     ADCCON2,#CHAN      ; ����� �������������� ������
	MOV     DACCON,#03DH	; ��������� ��� 0-5� 12���
	CPL      LED                                  ; CPL LED with each transmission

	MOV     A,#01H		; ��������
	SETB    SCONV                            ; ������������� ��� ��������������
        		         
	JNB     ADCI,$		;��� ����������� ��� ��������������� ���������� �� 				;����� ������������ ����� �������������� ���
	CLR	ADCI		;��������� ���� ���������� 
;�������� ������:
	MOV     DAC0H,ADCDATAH     ; ����� ����
	MOV     DAC0L,ADCDATAL
	MOV     R1,ADCDATAH             ; ����� ���������� � ���� HL ���� 
	MOV     R2,ADCDATAL               ; ������� ������

;�������� �������� ������

	mov R3,#00h  ;��������
	mov R4,#00h  ;�������


;===========��������� 16 ������� ����� �� 1.5==============	

	mov A,R1
	RRC A
	mov R3,A

 	mov A,R2
	RRC A
	ADD A,R2
	mov R2,A
	
	mov A,R3
	ADDC A,R1
	mov R1,A
	mov R3,#00h

;=======������� � 10_�� ������� ���������==============

;������ ���� ��� ������� ��������
	mov R0,#08h
cicl1::
;����� ��������� ����� �����
	mov A,R1
	RLC A
	mov R1,A
;�������-���������� �������� �����
	mov A,R4
	ADDC A,R4
	DA A
	mov R4,A
	mov A,R3
	ADDC A,R3
	DA A
	mov R3,A
	DJNZ R0,cicl1

;������ ���� ��� ������� ��������
	mov R0,#08h
cicl2::
;����� ��������� ����� �����
	mov A,R2
	RLC A
	mov R2,A
;�������-���������� �������� �����
	mov A,R4
	ADDC A,R4
	DA A
	mov R4,A
	mov A,R3
	ADDC A,R3
	DA A
	mov R3,A
	DJNZ R0,cicl2	
 
;������ ������ �������� �� ��� ����� ������
	mov R5,#02H
	mov DPP,#08h
;���� �� ����� ��������
;����� 1 ����� �� ������˨���� ������� ���!

	MOV DPTR,#0006H
	MOV A,#08H         ;������ �������
	movX @DPTR,A
	
	MOV A,#09H          ;���������
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#82H          ;���������� ���������� �������
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;������ ������
	movX @DPTR,A
	
	MOV A,#0DH         ;���������
	movX @DPTR,A

	mov A,R3
	anl A,#0F0h
	RR A
	RR A
	RR A
	RR A

	ADD A,#30h
		
	lCALL     SENDCHAR

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 
	
;����� ������� � ������˨���� ������� ���!

	MOV DPTR,#0006H
	MOV A,#08H         ;������ �������
	movX @DPTR,A
	
	MOV A,#09H          ;���������
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#83H          ;���������� ���������� �������
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;������ ������
	movX @DPTR,A
	
	MOV A,#0DH         ;���������
	movX @DPTR,A

	mov A,#00101100B
			
	lCALL     SENDCHAR

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 
;����� 2 ����� �� ��������� ������� ���!

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

	mov A,R3
	anl A,#0Fh
	ADD A,#30h
	
	lCALL     SENDCHAR

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 

;����� 3 ����� �� ��������� ������� ���!

	MOV DPTR,#0006H
	MOV A,#08H         ;������ �������
	movX @DPTR,A
	
	MOV A,#09H          ;���������
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#85H          ;���������� ���������� �������
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH         ;������ ������
	movX @DPTR,A
	
	MOV A,#0DH         ;���������
	movX @DPTR,A

	mov A,R4
	anl A,#0F0h
	RR A
	RR A
	RR A
	RR A

	ADD A,#30h

	lCALL     SENDCHAR
	
	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE  

;����� 4 ����� �� ��������� ������� ���!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#86H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A

	mov A,R4
	anl A,#0Fh
	ADD A,#30h
	
	lCALL     SENDCHAR	

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 

;������	
	MOV      A, #20H
	lCALL     SENDCHAR

;����� �����!

	MOV DPTR,#0006H
	MOV A,#08H
	movX @DPTR,A
	
	MOV A,#09H
	movX @DPTR,A
	
	MOV DPTR,#0001H
	MOV A,#88H
	movX @DPTR,A
	lcall PAUSE 
		
	MOV DPTR,#0006H
	MOV A,#0CH
	movX @DPTR,A
	
	MOV A,#0DH
	movX @DPTR,A

	mov A,#01000010B
	
	lCALL     SENDCHAR	

	MOV DPTR,#0001H
	movX @DPTR,A
	lcall PAUSE 
		
;����� ������ ����
; Every eight transmissions start on a new line
                  MOV      A, #10       ; Transmit a linefeed
	lCALL     SENDCHAR
	MOV      A, #13       ; Transmit a carriage return
	lCALL     SENDCHAR
	
;�������� 5� ����� �������� ������
	lCALL DELAY 
	ljmp MAIN


;����� �������� �� ����� ����� UART (� Giper Terminal)
;=======��������� ������ ������� �� ��� ASCII-����======================
                                                           ; SENDCHAR

SENDCHAR:       ; sends ASCII value contained in A to UART

        	JNB     TI,$            ; wait til present char gone
	CLR     TI              ; must clear TI
	MOV     SBUF,A

	RET

;=======�������� ������ ����������==================================
                                                            ; SENDVAL

SENDVAL:        ; converts the hex value of A into two ASCII chars,
		; and then spits these two characters up the UART.
                ; does not change the value of A.

        PUSH    ACC
        SWAP    A
        lCALL    HEX2ASCII
        lCALL    SENDCHAR        ; send high nibble
        POP     ACC
        PUSH    ACC
        lCALL    HEX2ASCII
        lCALL    SENDCHAR        ; send low nibble
        POP     ACC

        RET


;====��������������� ������� � ASCII-���==============================
                                                          ; HEX2ASCII

HEX2ASCII:      ; converts A into the hex character representing the
                ; value of A's least significant nibble

        ANL     A,#00Fh
        CJNE    A,#00Ah,$+3
        JC      IO0030
        ADD     A,#007h
IO0030: ADD     A,#'0'

        RET

;======================����� �� ����� �������========================
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

;===================�������� 5�====================================
DELAY:					; Delays by 100ms * A
					; 100mSec based on 2.097152MHZ 
					; Core Clock 
					; 
	
	MOV	R5,#400		; Acc holds delay variable (1 clock)
DLY0:	MOV	R6,#05Bh	; Set up delay loop0 (2 clocks)
DLY1:	MOV	R7,#0FFh	; Set up delay loop1 (2 clocks)
	DJNZ	R7,$		; Dec R7 & Jump here until R7 is 0 (3 clocks)
	DJNZ	R6,DLY1         ; Dec R6 & Jump DLY1 until R6 is 0 (3 clocks)
	DJNZ	R5,DLY0		; Dec R5 & Jump DLY0 until R5 is 0 (3 clocks)
	RET			; Return from subroutine          
	
	.END
	


	

