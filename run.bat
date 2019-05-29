@ECHO OFF
chcp 1250
python CzekerEyes/run.py | CheckerService.exe.lnk  | ScrabbleCzeker.exe.lnk
pause