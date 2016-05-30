echo off
cls
t167b 0x%2 0x0 addhexstart %1 bye
t167b 1 12 openchannel loadhex %1 closechannel bye
pause
