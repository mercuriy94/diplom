#INCLUDE	"DEFINE.ASM"  

;mov A,#11000010b 
;movx @DPTR,A  

main:
	lcall initENA ; ����� ������������ ������������� ����� ENA, ������������ �� ����� ������
	mov A,#00000000b 
	movx @DPTR,A  
loop:
	ljmp loop;

initENA::			;������������ ������������� ����� ENA		
	mov DPP,#08h	;����� �������� ����
	mov DPTR,#0004H	;����� �������� � ����, ���������������� ��� ��������� ����� ENA
	mov A,#01h
	movx @DPTR,A	;��������� ����� �� ����� ������, ����� ���� EN_LO
	mov DPTR,#0002h ;����� �������� � ���� EN_LO
	ret				;������� �� ������������

 .end
 
 