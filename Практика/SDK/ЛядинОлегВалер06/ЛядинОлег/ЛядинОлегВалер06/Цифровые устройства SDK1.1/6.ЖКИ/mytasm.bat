tasm.exe  -h -51 TUSUR.ASM i2c.HEX

if exist TUSUR.hex t167b 0x0000 0x0 addhexstart TUSUR.hex bye
t167b 1 12 openchannel loadhex TUSUR.hex closechannel bye

