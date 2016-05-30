tasm.exe -h -51 UART.ASM UART.HEX

if exist UART.hex t167b 0x0000 0x0 addhexstart UART.hex bye
t167b 1 12 openchannel loadhex UART.hex bye