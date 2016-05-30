tasm.exe  -h -51 LABA1.asm LABA1.hex
if exist LABA1.hex t167b 0x0111 0x0 addhexstart LABA1.hex bye
t167b 1 12 openchannel loadhex LABA1.hex closechannel bye
