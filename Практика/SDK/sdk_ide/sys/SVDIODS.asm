;############��������######
;������� ���������: ������� R0 ������ ��������� ������ 
;������� ���������� ������� � ���� �����������.
;�������� ���������: �����������.
;� ���� ������ �������� ������������: ��������(DPP,DPTR,A,R0)
;��� ������������� �������� ���������� ���� ��������������� 
;���������� INCLUDE ���� ����������� ��� ��������

;************ ������ �������� ������� ����������� ****************
#INCLUDE	"DEFINE.ASM"
SVDIODS::
	mov DPP,#08H 		;��������� �� 8 �������� ������
	MOV DPTR,#0007H		;��������� ��������� �� ������� ����������� (SV)
	MOV A,R0			;����������� ������� ������ � ������� � 
	MOVX @DPTR,A		;����� ������ �� ������� �����������
	RET
.END
;************ ����� �������� ������� ����������� ****************