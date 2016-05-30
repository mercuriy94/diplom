tasm.exe  -h -51 clock.ASM clock.HEX

if exist clock.hex t167b 0x0000 0x0 addhexstart clock.hex bye
t167b 1 12 openchannel loadhex clock.hex closechannel bye

