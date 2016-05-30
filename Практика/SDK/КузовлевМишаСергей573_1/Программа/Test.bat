tasm.exe  -h -51 Test.ASM Test.HEX

if exist Test.hex t167b 0x0000 0x0 addhexstart Test.hex bye
t167b 1 12 openchannel loadhex Test.hex closechannel bye

