tasm.exe -h -51 kal.ASM kal.HEX

if exist kal.hex t167b 0x0000 0x0 addhexstart kal.hex bye
t167b 1 12 openchannel loadhex kal.hex bye