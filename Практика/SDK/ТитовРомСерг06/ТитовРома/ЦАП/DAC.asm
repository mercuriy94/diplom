#include define.asm
CHAN    .EQU	1000B               ; ����� ������ �������������� �������
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
    	MOV     ADCCON1,#0ACh         ; ���������� �������� ���
	MOV     ADCCON2,#CHAN      ; ����� �������������� ������
	MOV     DACCON,#03DH	; ��������� ��� 0-5� 12���
	SETB    SCONV                            ; ������������� ��� ��������������
  		         
	JNB     ADCI,$		;��� ����������� ��� ��������������� ���������� �� 				;����� ������������ ����� �������������� ���
	CLR	ADCI		;��������� ���� ���������� 
;�������� ������:
	MOV     DAC0H,ADCDATAH     ; ����� ����
	MOV     DAC0L,ADCDATAL
	
.END
	


	

