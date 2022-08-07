@echo off

set BASEPATH=%~dp0

REM Disabilito Autorun

MKDIR %HOMEDRIVE%\autoRun.Inf
attrib +r +h +s %HOMEDRIVE%\autoRun.Inf
icacls %HOMEDRIVE%\autoRun.Inf /deny everyone:F

dir D:\
IF %ERRORLEVEL% EQU 0 (
	MKDIR D:\autoRun.Inf
	attrib +r +h +s D:\autoRun.Inf
	icacls D:\autoRun.Inf /deny everyone:F
)

dir E:\
IF %ERRORLEVEL% EQU 0 (
	MKDIR E:\autoRun.Inf
	attrib +r +h +s E:\autoRun.Inf
	icacls E:\autoRun.Inf /deny everyone:F
)

REM Copio i tools in C:\bin
mkdir %HOMEDRIVE%\bin
robocopy /mt:128 /S /E /R:0 /W:0 %BASEPATH%\bin %HOMEDRIVE%\bin

REM Imposto C:\bin sulla variabile PATH...
setx /M PATH "%PATH%;C:\bin"

REM Installo Chocolatey
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM Tools
choco install -y 7zip
choco install -y notepadplusplus
choco install -y wiztree
choco install -y naps2
choco install -y adobereader

REM Net/Sys tools
choco install -y FileZilla

REM Audio/Video
choco install -y VideoLAN.VLC
choco install -y irfanview irfanviewplugins
choco install -y audacity

REM Office
choco install -y Google.Chrome
choco install -y pdfsam pdf24
choco install -y libreoffice

REM Link di Aiuto sul desktop
mklink %PUBLIC%\Desktop\AIUTO "C:\Windows\Sytem32\quickassist.exe"

REM Escludo l'ibernazione...
powercfg /hibernate off

REM Disattivo servizi non utili
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
sc config "NaturalAutentication" start= disabled
sc config "NgcCtnrSvc" start= disabled
sc config "WpcMonSvc" start= disabled
sc config "SEMgrSvc" start= disabled
sc config "MicrosoftEdgeElevationService" start= disabled
sc config "edgeupdate" start= disabled
sc config "edgeupdatem" start= disabled
sc config "AppReadiness" start= disabled
sc config "SensorDataService" start= disabled
sc config "SharedRealitySvc" start= disabled
sc config "WMPNetworkSvc" start= disabled
sc config "EntAppSvc" start= disabled
sc config "TroubleshootingSvc" start= disabled
sc config "SensorService" start= disabled
sc config "PhoneSvc" start= disabled
sc config "wisvc" start= disabled
sc config "ZoomCptService" start= manual

REM Importo l'associazione files per tutti gli utenti
if EXIST %BASEPATH%\AppAssociations\AppAssociations.xml (
dism /online /Import-DefaultAppAssociations:"%BASEPATH%\AppAssociations\AppAssociations.xml"
)

REM Rimuovo AppXProvisionedPackage per tutti gli utenti
powershell Set-ExecutionPolicy Bypass -Scope Process -Force; %BASEPATH%\appxRemove.ps1

start C:\dism++x64.exe
start C:\WPD.exe