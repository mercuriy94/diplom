tasm.exe -h -51 ADC.ASM ADC.HEX

if exist ADC.hex t167b 0x0000 0x0 addhexstart ADC.hex bye
t167b 1 12 openchannel loadhex ADC.hex bye