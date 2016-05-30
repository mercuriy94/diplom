#include define.asm
CHAN    .EQU	1000B               ; выбор канала температурного сенсора
	                          ; 
;____________________________________________________________________
                                                  ; начало
CSEG

.ORG 0000h
		
	lJMP MAIN            ; jump to main program

; прога
.ORG 004Bh

MAIN:

; PRECONFIGURE...
    	MOV     ADCCON1,#0ACh         ; насторойка регистра АЦП
	MOV     ADCCON2,#CHAN      ; выбор установленного канала
	MOV     DACCON,#03DH	; установка ЦАП 0-5В 12бит
	SETB    SCONV                            ; инициализация АЦП преобразования
  		         
	JNB     ADCI,$		;бит прерываняия АЦП установливается однократно по 				;концу однократного цикла преобразования АЦП
	CLR	ADCI		;обнуление бита прерывания 
;исходные данные:
	MOV     DAC0H,ADCDATAH     ; вывод ЦАПа
	MOV     DAC0L,ADCDATAL
	
.END
	


	

