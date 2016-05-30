cls
tasm.exe  -h -51 %1 %2
echo off 
if errorlevel 1 del %2
pause