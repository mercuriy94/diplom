DPTR	.EQU	30H
DPP     .equ	84h
ACC	.equ	0E0h
RS0     .EQU    0D3H
RS1     .EQU    0D4H
PSW     .equ    0D0H
T0	.equ	0B4H
	
	
P0      .equ	080h
SP      .equ    081h
DPL     .equ    082h
DPH     .equ    083h
DPP     .equ    084h
PCON    .equ    087h
TCON    .equ    088h
TMOD    .equ    089h
TL0     .equ	08Ah
TL1     .equ    08Bh
TH0     .equ    08Ch
TH1     .equ 	08Dh
P1      .equ	090h
SCON    .equ 	098h
SBUF    .equ    099h
I2CDAT  .equ	09Ah
I2CADD  .equ	09Bh
T3FD    .equ	09Dh
T3CON   .equ	09Eh
P2      .equ	0A0h
TIMECON .equ	0A1h
HTHSEC  .equ	0A2h
SEC     .equ	0A3h
MIN     .equ	0A4h
HOUR    .equ	0A5h
INTVAL  .equ	0A6h
DPCON   .equ	0A7h
IE      .equ	0A8h
IEIP2   .equ	0A9h
PWMCON  .equ	0AEh
CFG831  .equ	0AFh
P3      .equ	0B0h
PWM0L   .equ	0B1h
PWM0H   .equ	0B2h
PWM1L   .equ	0B3h
PWM1H   .equ	0B4h
SPH     .equ	0B7h
IP      .equ	0B8h
ECON    .equ	0B9h
EDATA1  .equ	0BCh
EDATA2  .equ	0BDh
EDATA3  .equ	0BEh
EDATA4  .equ	0BFh
WDCON   .equ	0C0h
CHIPID  .equ	0C2h
EADRL   .equ	0C6h
EADRH   .equ	0C7h
T2CON   .equ	0C8h
RCAP2L  .equ	0CAh
RCAP2H  .equ	0CBh
TL2     .equ	0CCh
TH2     .equ	0CDh
PSW     .equ	0D0h
DMAL    .equ	0D2h
DMAH    .equ	0D3h
DMAP    .equ	0D4h
ADCCON2 .equ	0D8h
ADCDATAL	.equ	0D9h
ADCDATAH	.equ	0DAh
PSMCON  .equ	0DFh
ACC     .equ	0E0h
DCON    .equ	0E8h
I2CCON  .equ	0E8h
ADCCON1 .equ	0EFh
B       .equ	0F0h
ADCOFSL .equ	0F1h
ADCOFSH .equ	0F2h
ADCGAINL	.equ	0F3h
ADCGAINH	.equ	0F4h
ADCCON3 .equ	0F5h
SPIDAT  .equ	0F7h
SPICON  .equ	0F8h
DAC0L   .equ	0F9h
DAC0H   .equ	0FAh
DAC1L   .equ	0FBh
DAC1H   .equ	0FCh
DACCON  .equ	0FDh


TF1     .equ	08Fh
TR1     .equ	08Eh
TF0     .equ	08Dh
TR0     .equ	08Ch
IE1     .equ	08Bh
IT1     .equ	08Ah
IE0     .equ	089h
IT0     .equ	088h

T2EX    .equ	091h
T2      .equ	090h

SM0     .equ	09Fh
SM1     .equ	09Eh
SM2     .equ	09Dh
REN     .equ	09Ch
TB8     .equ	09Bh
RB8     .equ	09Ah
TI      .equ	099h
RI      .equ	098h

EA      .equ	0AFh
EADC    .equ	0AEh
ET2     .equ	0ADh
ES      .equ	0ACh
ET1     .equ	0ABh
EX1     .equ	0AAh
ET0     .equ	0A9h
EX0     .equ	0A8h

RD      .equ	0B7h
WR      .equ	0B6h
T1      .equ	0B5h
T0      .equ	0B4h
INT1    .equ	0B3h
INT0    .equ	0B2h
TXD     .equ	0B1h
RXD     .equ	0B0h

PSI     .equ	0BFh
PADC    .equ	0BEh
PT2     .equ	0BDh
PS      .equ	0BCh
PT1     .equ	0BBh
PX1     .equ	0BAh
PT0     .equ	0B9h
PX0     .equ	0B8h

PRE3    .equ	0C7h
PRE2    .equ	0C6h
PRE1    .equ	0C5h
PRE0    .equ	0C4h
WDIR    .equ	0C3h
WDS     .equ	0C2h
WDE     .equ	0C1h
WDWR    .equ	0C0h

TF2     .equ	0CFh
EXF2    .equ	0CEh
RCLK    .equ	0CDh
TCLK    .equ	0CCh
EXEN2   .equ	0CBh
TR2     .equ	0CAh
CNT2    .equ	0C9h
CAP2    .equ	0C8h

CY      .equ	0D7h
AC      .equ	0D6h
F0      .equ	0D5h
RS1     .equ	0D4h
RS0     .equ	0D3h
OV      .equ	0D2h
F1      .equ	0D1h
P       .equ	0D0h

ADCI    .equ	0DFh
DMA     .equ	0DEh
CCONV   .equ	0DDh
SCONV   .equ	0DCh
CS3     .equ	0DBh
CS2     .equ	0DAh
CS1     .equ	0D9h
CS0     .equ	0D8h

D1      .equ	0EFh
D1EN    .equ	0EEh
D0      .equ	0EDh
D0EN    .equ	0EBh

MDO     .equ	0EFh
MDE     .equ	0EEh
MCO     .equ	0EDh
MDI     .equ	0ECh
I2CM    .equ	0EBh
I2CRS   .equ	0EAh
I2CTX   .equ	0E9h
I2CI    .equ	0E8h

ISPI    .equ	0FFh
WCOL    .equ	0FEh
SPE     .equ	0FDh
SPIM    .equ	0FCh
CPOL    .equ	0FBh
CPHA    .equ	0FAh
SPR1    .equ	0F9h
SPR0    .equ	0F8h
        .END