tasm.exe -h -51 temper.ASM temper.HEX

if exist temper.hex t167b 0x0000 0x0 addhexstart temper.hex bye
t167b 1 12 openchannel loadhex temper.hex bye