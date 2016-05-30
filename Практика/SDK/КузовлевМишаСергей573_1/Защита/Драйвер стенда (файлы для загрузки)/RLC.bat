tasm.exe  -h -51 RLC.ASM RLC.HEX

if exist RLC.hex t167b 0x0000 0x0 addhexstart RLC.hex bye
t167b 1 12 openchannel loadhex RLC.hex closechannel bye

