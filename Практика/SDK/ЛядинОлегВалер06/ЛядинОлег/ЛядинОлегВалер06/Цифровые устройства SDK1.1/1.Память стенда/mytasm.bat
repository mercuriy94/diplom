tasm.exe  -h -51 EEPROM.ASM EEPROM.HEX

if exist EEPROM.hex t167b 0x0000 0x0 addhexstart EEPROM.hex bye
t167b 1 12 openchannel loadhex EEPROM.hex closechannel bye

