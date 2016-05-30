tasm.exe  -h -51 gerlanda.ASM i2c.HEX

if exist gerlanda.hex t167b 0x0000 0x0 addhexstart gerlanda.hex bye
t167b 1 12 openchannel loadhex gerlanda.hex closechannel bye

