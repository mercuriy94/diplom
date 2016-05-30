tasm.exe -h -51 dma.ASM dma.HEX

if exist dma.hex t167b 0x0000 0x0 addhexstart dma.hex bye
t167b 1 12 openchannel loadhex dma.hex bye