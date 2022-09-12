mode COM3 BAUD=9600 PARITY=n DATA=8
:start
@echo %time%
@set /p x=%time% < nul >\\.\COM3
sleepx64 5
@set /p x=%time% < nul >\\.\COM3
sleepx64 5
@set /p x=%time% < nul >\\.\COM3
sleepx64 300
@goto start
pause
@rem  > COM3
@rem set /p x="hello" < nul >\\.\COM3
rem http://microsin.net/programming/pc/serialsend-send-text-to-vcp.html