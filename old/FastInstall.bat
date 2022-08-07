REM FastInstall 3.1
REM Picolmeme Software House

@echo off
SETLOCAL
color 0A

:intro
cls
set prgver="3.1"
title FastInstall ver:%prgver%

echo # Benvenuto nell'utility FastInstall ver. %prgver%...
echo.

:check_Permissions
    echo # Rilevamento privilegi amministrativi...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Trovati privilegi amministrativi...
		echo Procedo con l'installazione...
		echo.
		goto menu
    ) else (
		echo ### ERRORE ###
        echo Non hai i privilegi di amministrazione!
		echo Chiudi il programma e riavvialo con privilegi amministrativi!
		pause
		goto outro
    )

:menu

set fipath=%~dp0

cls
echo # %DATE%
echo # %TIME%

:accounts-setup
echo # Accounts Set Up...

%fipath%accounts-setup.bat

echo.
echo # Operazione completata!

:tweaks
cls
echo # Applico Tweaks...
echo.

%fipath%tweaks.bat

echo.
echo # Operazione completata con successo!

goto chocoinstall

:chocoinstall
cls
echo # Controllo installazione di chocolatey...
echo.
IF ERRORLEVEL 9009 (
echo # %DATE%
echo # %TIME%
echo # Procedo all'installazione di Chocolatey...
echo.
%fipath%choco-install.bat
echo.
echo # Riavviare il terminale!
pause
exit
) ELSE (
echo.
echo # Chocolatey già installato!
goto prginstall
)

:erroralert
cls
echo # errorlevel = %ERRORLEVEL%
echo # Qualcosa è andato storto...
pause
goto outro

:prginstall
cls

echo # Procedo all'installazione dei programmi...
%fipath%apps.bat
echo.
echo # Operazione completata con successo!

goto outro

:outro
cls
echo # Installazione completata, Vuoi riavviare?
CHOICE /C SN /T 10 /D N

IF ERRORLEVEL 2 goto bye
IF ERRORLEVEL 1 shutdown -r -f -t 0

:bye
color 0f
cls
echo.
echo # Grazie per aver schelto PicolmemeSoftwareHouse!
echo.
echo.
@echo on