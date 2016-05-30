tasm.exe -h -51 DAC.ASM DAC.HEX

if exist DAC.hex t167b 0x0000 0x0 addhexstart DAC.hex bye
t167b 1 12 openchannel loadhex DAC.hex bye