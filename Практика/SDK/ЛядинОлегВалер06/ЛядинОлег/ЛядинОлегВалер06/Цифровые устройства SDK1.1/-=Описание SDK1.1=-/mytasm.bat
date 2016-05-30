tasm.exe  -h -51 zki.ASM i2c.HEX

if exist zki.hex t167b 0x0000 0x0 addhexstart zki.hex bye
t167b 1 12 openchannel loadhex zki.hex closechannel bye

