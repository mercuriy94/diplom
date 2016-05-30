echo off
if exist %1  (
	t167b 0x0000 0x0 addhexstart %1 bye
	t167b 1 12 openchannel loadhex %1 closechannel bye
	pause
) else ( 
	echo !!!!!---FILE %1% DOES NOT EXIST---!!!!!
	pause
) 