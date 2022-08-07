REM OfflineInstall 1.0
REM Picolmeme Software House

@echo off
color 0A
:intro
cls
set prgver="1.0"
title FastInstall ver:%prgver%

echo # Benvenuto nell'utility OfflineInstall ver. %prgver%...
echo.

:check_Permissions
    echo Rilevamento privilegi amministrativi...

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

set fipath=E:\FastInstall\

cls
echo # %DATE%
echo # %TIME%
echo # Scegli cosa fare...
echo.
echo 1] Accounts-setup & Tweaks
echo 2] Installazione programmi
echo 3] Tweaks-only
echo 4] Exit
echo.

CHOICE /C 1234 /T 4 /D 1
IF ERRORLEVEL 255 goto erroralert
IF ERRORLEVEL 4 goto outro
IF ERRORLEVEL 3 goto tweaks
IF ERRORLEVEL 2 goto prginstall
IF ERRORLEVEL 1 goto accounts-setup
IF ERRORLEVEL 0 goto erroralert

:accounts-setup
cls
echo # Impostazione Cartelle utente nel disco D:\...

MKDIR D:\Users
MKDIR D:\autoRun.Inf
attrib +r +h +s D:\autoRun.Inf
icacls D:\autoRun.Inf /deny everyone:F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /t REG_EXPAND_SZ /v "ProfilesDirectory" /d "D:\Users" /F

echo.
echo # Creazione nuovo utente amministratore...
echo.
echo # Inserisci nome utente:
echo.

set /P usrnamea=# 

net user %usrnamea% /ADD
net localgroup Administrators %usrnamea% /ADD

echo.
echo # Utente amministratore creato...
echo.
echo # Inserici nome utente NON privilegiato...
echo # premi invio per annullare.
echo.

set usernames="baudo"
set /P usrnames=# 
IF %usernames%=="baudo" (goto tweaks) ELSE (net user %usernames% /ADD)

goto tweaks

:erroralert
cls
echo # errorlevel = %ERRORLEVEL%
echo # Qualcosa è andato storto...
pause
goto outro

:prginstall
cls

echo # Procedo all'installazione dei programmi...
echo.

echo # Installo i programmi...
echo.

REM TODO

echo.
echo.
echo # Installare i tools per la protezione?
echo.
CHOICE /C SN /D 2 /T 4

IF ERRORLEVEL 1 (

REM TODO

copy %fipath%softwarepolicy.ini C:\Windows\SoftwarePolicy\softwarepolicy.ini
)
	
echo # Aggiungo Assistenza Remota su Desktop...
mklink %PUBLIC%\Desktop\AIUTO C:\Windows\System32\quickassist.exe

echo # Cambio assiociazioni predefinite...
IF EXIST %fipath%WinFileAssoc.xml (Dism.exe /online /import-defaultappassociations:%fipath%WinFileAssoc.xml) ELSE (echo # Non è presente il file di associazione...)
	
echo.
echo # Installazione completata! )
IF ERRORLEVEL 0 (goto outro) ELSE (goto erroralert)

:tweaks
cls
echo # Applico Tweaks...
echo.

REM echo # Premi 'N' per saltare...
REM CHOICE /C SN /T 4 /D S
REM IF ERRORLEVEL 255 goto outro
REM IF ERRORLEVEL 2 goto outro
REM IF ERRORLEVEL 1 (
REM	echo.

echo # Sysinternarls e binari...
robocopy /mt:128 /s /W:0 /R:0 E:\bin C:\bin

echo # Imposto scadenza illimitata delle password per tutti gli account locali...
powershell net accounts /maxpwage:UNLIMITED
	
echo.
echo # Imposto C:\bin sulla variabile PATH...
setx /M PATH "%PATH%;C:\bin"
	
echo.
echo # Escludo l'ibernazione...
powercfg /hibernate off
	
echo.
echo # Escludo servizi non necessari...
sc config "DusmSvc" start= disabled
sc config "CscService" start= disabled
sc config "ForensiTAppxService" start= disabled
sc config "XblAuthManager" start= disabled
sc config "MapsBroker" start= disabled
sc config "XblGameSave" start= disabled
sc config "iphlpsvc" start= disabled
sc config "WdiServiceHost" start= disabled
sc config "WdiSystemHost" start= disabled
sc config "AppReadiness" start= disabled
sc config "LanmanServer" start= demand
sc config "DPS" start= disabled
sc config "RetailDemo" start= disabled
sc config "WbioSrvc" start= disabled
sc config "lfsvc" start= disabled
sc config "spectrum" start= disabled
sc config "XboxNetApiSvc" start= disabled
sc config "perceptionsimulation" start= disabled
sc config "WpnService" start= disabled
sc config "BITS" start= disabled
sc config "UevAgentService" start= disabled
sc config "SQLWriter" start= disabled
sc config "SysMain" start= disabled
sc config "TapiSrv" start= disabled
sc config "Themes" start= disabled
sc config "WalletService" start= disabled
sc config "WSearch" start= disabled
sc config "XboxGipSvc" start= disabled

goto outro

:outro
echo.
color 0f
@echo on
cls
