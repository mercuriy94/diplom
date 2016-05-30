tasm.exe  -h -51 Plis.ASM Plis.HEX

if exist Plis.hex t167b 0x0000 0x0 addhexstart Plis.hex bye
t167b 1 12 openchannel loadhex Plis.hex closechannel bye
 





