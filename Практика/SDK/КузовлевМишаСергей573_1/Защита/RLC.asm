#INCLUDE	"DEFINE.ASM"   		; ����������� ������� sfr-���������.
	.ORG	0h
	ljmp	START
	.ORG	23h
	ljmp	UART_int
	.ORG	100h

;+++++++++++++++++ ������ ��������� ++++++++++++++++++++++++++++++++
START::
	MOV	PLLCON,#51h	; ������� ���������� 16,77 / 2 = 8,38���
	MOV	T3CON,#85h		; ��������� �������� COM-����� ����� ������ 3 	
	MOV	T3FD,#2Dh		; �������� �������� ������ 9600 ���
	MOV	SCON,#50h		; UART (COM-����)
	MOV	DPP,#08h		; ��������� �����. ������ ��� ������� � ��������� ���C.
	MOV 	DPTR,#0007H	; ����� �������� ���������� ������������.
	LCALL	PAUSE 	; ����� ������������ �����.
	MOV	A,#011H		; ��������� ������ "00" � ����������� �.
	MOVX	@DPTR,A
	SETB	ES
	SETB	EA
LOOP_PROG:
	LJMP	LOOP_PROG
;+++++++++++++++++ ���������� ���-����� ++++++++++++++++++++++++++++
UART_int:
	CLR 	ES
	CLR	RI
	CLR	TI
	MOV	R3,SBUF		;������� �������� ������� �������������
	MOV	A,R3
	CJNE	A,#0C3h,INT_END	; ������ ������ ������� �����������
	LCALL	VOZV1
	MOV	A,#0FEh	
	MOV	SBUF,A
	JNB	TI,$			; ��������� ������
	CLR	TI
	MOV	A,#0FEh	
	MOV	SBUF,A
	JNB	TI,$			; ��������� ������
	CLR	TI

INT_END:
	CJNE	A,#0C4h,END1
	MOV	A,#0C4h
	MOV	SBUF,A
	JNB	TI,$			; ��������� ������
	CLR	TI
	MOV	A,#0C4h
	MOV	SBUF,A
	JNB	TI,$			; ��������� ������
	CLR	TI
END1:
	MOV	DPP,#08h		; ��������� �����. ������ ��� ������� � ��������� ���C.
	MOV 	DPTR,#0007H	; ����� �������� ���������� ������������.
	LCALL	PAUSE 	; ����� ������������ �����.
	MOV	A,#022H		; ��������� ������ "00" � ����������� �.
	MOVX 	@DPTR,A
	SETB	ES
	RETI
;+++++++++++++++++ ����� ���������� ++++++++++++++++++++++++++++++++++

;+++++++++++++++++ ��������� ���0 ++++++++++++++++++++++++++++++++++++
VOZV1: 

	MOV	DACCON,#00001101B; ����� ������ ���0 12���, ����������� �����
	MOV	DAC0H,#000h	; ��������� ���������� ������ �������
	MOV	DAC0L,#000h	; 
	MOV	R5,#00H		; ������� DPH
	MOV	R6,#00H		; ������� DPL
VOZV:
	MOV	ADCCON1,#10001100B; ��������� ��� � ���������� ;������ � ���������� �����
	MOV	DPTR,#TABLE
	MOV	R2,#00H		; ������� ������ ��������� 64 (40H)
STEP: 
	CLR	A			; �������� �����������
	MOVC	A,@A+DPTR	; ��������� ������ � ����������� �� ������� ������
	MOV	DAC0H,A		; ��������� ������ � ������� ������� ���
	INC	DPTR			; ������� �� ��������� ����� � �������
	CLR	A			; �������� �����������
	MOVC	A,@A+DPTR	; ��������� ������ � ����������� �� ������� ������
	MOV	DAC0L,A		; ��������� ������ � ������� ������� ���
	INC	DPTR			; ������� �� ��������� ����� � �������
	INC	R4			; ��������� �������� ������ ������ ���
	LCALL	PAUSE
	INC	R2
	nop

	CJNE	R4,#001h,ADC1
	MOV	ADCCON2,#00000001B; ��������� �������� ������	
	LCALL	ADC
	MOV	ADCCON2,#00000000B; ��������� �������� ������
	SJMP	DDD
ADC1:
	MOV	R4,#00H
	MOV	ADCCON2,#00000000B; ��������� �������� ������
	LCALL	ADC
	MOV	ADCCON2,#00000000B; ��������� �������� ������
DDD:
	CJNE	R5,#008h,NOPER
	SJMP	DIOD
NOPER:	
	CJNE	R2,#040h,STEP1	; �������� �� ����� ������� ������? �������� �� �������� 
	LJMP	VOZV			; ������� �� �����.
STEP1:
	LJMP 	STEP
;+++++++++++++++++++++++++++   ������ �� ������ � ��  ++++++++++++++++
DIOD:
	MOV	DPP,#08h		; ��������� �������� ������ ��� ������� � ��������� ���C.       
	MOV 	DPTR,#0007H	; ����� �������� ���������� ������������.
	LCALL	PAUSE 	; ����� ������������ �����.
	MOV 	A,#0DDH		; ��������� ������ "00" � ����������� �.
	MOVX	@DPTR,A
	MOV	DPP,#00h
	MOV	DPTR,#0000H	
PERED:
	MOVX	A,@DPTR
	INC	DPTR
	MOV	SBUF,A
	JNB	TI,$			; ��������� ������
	CLR	TI
	LCALL 	PAUSE
	MOV	A,DPH
	MOV	R5,A
	CJNE	R5,#008h,PERED
	MOV	DPP,#08h		; ��������� �������� ������ ��� ������� � ��������� ���C.
	MOV	DPTR,#0007H	; ����� �������� ���������� ������������.
	LCALL	PAUSE 	; ����� ������������ �����.
	MOV	A,#0FFH		; ��������� ������ "00" � ����������� �.
	MOVX	@DPTR,A
	MOV	R3,#00h
	RET
;++++++++++++++++ ������ � ������ �� ���1 +++++++++++++++++++++++++++
ADC:	
	PUSH	DPL
	PUSH	DPH
	MOV	DPP,#00h
	MOV	A,R5
	MOV	DPH,A
	MOV	A,R6
	MOV	DPL,A
	MOV	ADCCON3,#00000000b
	SETB	SCONV 		; ������������� ������������ ��������������
	MOV	A,ADCDATAH 
	MOVX	@DPTR,A
	INC	DPTR
	MOV	A,ADCDATAL 
	MOVX	@DPTR,A
	INC	DPTR
	MOV	A,DPH
	MOV	R5,A
	MOV	A,DPL
	MOV	R6,A
	POP	DPH
	POP	DPL
	RET
;++++++++++++++++++++++++++   ����� (78 ���)  ++++++++++++++++++++++++
					; R1-6 R2-22 = 200��
PAUSE:	
	PUSH	PSW			; ������ ������������ �����.
	MOV	R1,#006H		; ��������� ������ "CC" � ������� R1.
MP1:
	MOV	R0,#022H
MP2:
	DJNZ	R0,MP2		; ���� �������� �������� �� 0, �� ������� �� �����.
	DJNZ	R1,MP1
	POP	PSW
	RET				; ����� �� ������������.
;++++++++++++++++++++  ������� ������   ++++++++++++++++++++++++++++++
.ORG  01000H
TABLE:
.DB  007h, 0FFh
.DB  008h, 0C8h
.DB  009h, 08Eh
.DB  00Ah, 051h
.DB  00Bh, 00Fh
.DB  00Bh, 0C4h
.DB  00Ch, 071h
.DB  00Dh, 012h
.DB  00Dh, 0A7h
.DB  00Eh, 02Eh
.DB  00Eh, 0A5h
.DB  00Fh, 00Dh
.DB  00Fh, 063h
.DB  00Fh, 0A6h
.DB  00Fh, 0D7h
.DB  00Fh, 0F5h
.DB  00Fh, 0FFh
.DB  00Fh, 0F5h
.DB  00Fh, 0D7h
.DB  00Fh, 0A6h
.DB  00Fh, 063h
.DB  00Fh, 00Dh
.DB  00Eh, 0A5h
.DB  00Eh, 02Eh
.DB  00Dh, 0A7h
.DB  00Dh, 012h
.DB  00Ch, 071h
.DB  00Bh, 0C4h
.DB  00Bh, 00Fh
.DB  00Ah, 051h
.DB  009h, 08Eh
.DB  008h, 0C8h
.DB  007h, 0FFh
.DB  007h, 036h
.DB  006h, 070h
.DB  005h, 0ADh
.DB  004h, 0EFh
.DB  004h, 03Ah
.DB  003h, 08Dh
.DB  002h, 0ECh
.DB  002h, 057h
.DB  001h, 0D0h
.DB  001h, 059h
.DB  000h, 0F1h
.DB  000h, 09Bh
.DB  000h, 058h
.DB  000h, 027h
.DB  000h, 009h
.DB  000h, 000h
.DB  000h, 009h
.DB  000h, 027h
.DB  000h, 058h
.DB  000h, 09Bh
.DB  000h, 0F1h
.DB  001h, 059h
.DB  001h, 0D0h
.DB  002h, 057h
.DB  002h, 0ECh
.DB  003h, 08Dh
.DB  004h, 03Ah
.DB  004h, 0EFh
.DB  005h, 0ADh
.DB  006h, 070h
.DB  007h, 036h          
;+++++++++++++++++++++++++++++++   ����� �������   ++++++++++++++++++
.end				; ����� ���������.
