@echo off
REM #----------------------------------------------------#
REM Prima di lanciare lo script configurare la sezione commentata di seguito

REM Selezionare il tipo di installazione
REM Cambiare il valore di INST con una delle seguenti scelte
REM home | office | manual | extreme

set INST="0"

REM Impostare il nome del PC
set PCNAME="Workstation-123"

REM Installare i bkp automatici?
set AUTOBKP=1

REM Impostare creazione automatica punti di ripristino?
set AUTORESTORE=1

REM Installare servizio per upgrade automatico?
set AUTOUPGRADE=1

REM Ottimizzare per pc portatili?
set LAPTOPMODE=0

REM Password per account Administrator (in automatico solo con installazioni "office")
set ADMPSW="Str0ngP4ssw0rd!!"

REM Impostare il sistema come Terminal Server?
set TERMSRV=0

REM #----------------------------------------------------#

set BASEPATH=%~dp0

if %INST% EQU 0 (
    echo "Non è stato selezionato il tipo di installazione..."
    echo "Configurare lo script e rilanciarlo"
    echo.
    pause
    exit
)

if %PCNAME% EQU "Workstation-123" (
    echo # - Digitare nome PC
    set /P PCNAME=
    echo.
    echo # - Nome PC: %PCNAME%
    echo # - Premi un tasto per confermare, CTRL-C per uscire
    pause>nul
)

REM # - Impostazioni sicure e comuni a tutti i tipi di installazione - #

REM Disabilito Autorun e Autoplay
MKDIR %HOMEDRIVE%\autoRun.Inf
attrib +r +h +s %HOMEDRIVE%\autoRun.Inf
icacls %HOMEDRIVE%\autoRun.Inf /deny everyone:F

dir D:\
IF %ERRORLEVEL% EQU 0 (
	MKDIR D:\autoRun.Inf
	attrib +r +h +s D:\autoRun.Inf
	icacls D:\autoRun.Inf /deny everyone:F
)

REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v DisableAutoplay /t REG_DWORD /d 1 /f

REM Copio i tools in C:\bin
mkdir %HOMEDRIVE%\bin
robocopy /mt:128 /S /E /R:0 /W:0 %BASEPATH%\bin %HOMEDRIVE%\bin

REM Copio config e scripts in C:\config e C:\scripts
mkdir %HOMEDRIVE%\config
robocopy /mt:128 /S /E /R:0 /W:0 %BASEPATH%\config %HOMEDRIVE%\config
mkdir %HOMEDRIVE%\scripts
robocopy /mt:128 /S /E /R:0 /W:0 %BASEPATH%\scripts %HOMEDRIVE%\scripts

REM Imposto C:\bin sulla variabile PATH...
setx /M PATH "%PATH%;C:\bin"
setx /M PATH "%PATH%;C:\scripts"

REM Opzioni di risparmio energia
if %LAPTOPMODE% EQU 1 (
    powercfg /hibernate on
    powercfg /change monitor-timeout-ac 10
    powercfg /change standby-timeout-ac 0
    powercfg /change monitor-timeout-dc 3
    powercfg /change standby-timeout-dc 10
) ELSE (
    powercfg /hibernate off
    powercfg /change monitor-timeout-ac 10
    powercfg /change standby-timeout-ac 0
)

REM Installazione applicativi di base
winget install -e -h VideoLAN.VLC --accept-source-agreements
winget install -e -h Insecure.Nmap
winget install -e -h Notepad++.Notepad++
winget install -e -h 7zip.7zip
winget install -e -h Cyanfish.NAPS2

REM Associazioni file di base
assoc .7z=7-Zip.7z
assoc .AAC=VLC.aac.Document
assoc .3ga=VLC.3ga.Document
assoc .3gp=VLC.3gp.Document
assoc .3gp2=VLC.3gp2.Document
assoc .3gpp=VLC.3gpp.Document
assoc .7z=7-Zip.7z
assoc .AAC=VLC.aac.Document
assoc .ac3=VLC.ac3.Document
assoc .avi=VLC.avi.Document
assoc .deb=7-Zip.deb
assoc .dmg=7-Zip.dmg
assoc .f4v=VLC.f4v.Document
assoc .flac=VLC.flac.Document
assoc .flv=VLC.flv.Document
assoc .gz=7-Zip.gz
assoc .gzip=7-Zip.gzip
assoc .m4a=VLC.m4a.Document
assoc .m4p=VLC.m4p.Document
assoc .m4v=VLC.m4v.Document
assoc .mkv=VLC.mkv.Document
assoc .mov=VLC.mov.Document
assoc .mp1=VLC.mp1.Document
assoc .mp2=VLC.mp2.Document
assoc .mp2v=VLC.mp2v.Document
assoc .mp3=VLC.mp3.Document
assoc .mp4=VLC.mp4.Document
assoc .mp4v=VLC.mp4v.Document
assoc .mpeg=VLC.mpeg.Document
assoc .mpeg1=VLC.mpeg1.Document
assoc .mpeg2=VLC.mpeg2.Document
assoc .mpeg4=VLC.mpeg4.Document
assoc .mpg=VLC.mpg.Document
assoc .rar=7-Zip.rar
assoc .tar=7-Zip.tar
assoc .tbz=7-Zip.tbz
assoc .tbz2=7-Zip.tbz2
assoc .tgz=7-Zip.tgz
assoc .zip=7-Zip.zip
assoc .jpg=PhotoViewer.FileAssoc.Tiff
assoc .png=PhotoViewer.FileAssoc.Tiff
assoc .jpeg=PhotoViewer.FileAssoc.Tiff
assoc .bmp=PhotoViewer.FileAssoc.Tiff
assoc .jpe=PhotoViewer.FileAssoc.Tiff
assoc .jfif=PhotoViewer.FileAssoc.Tiff
assoc .dib=PhotoViewer.FileAssoc.Tiff
assoc .ico=PhotoViewer.FileAssoc.Tiff
assoc .gif=PhotoViewer.FileAssoc.Tiff
assoc .tga=PhotoViewer.FileAssoc.Tiff


REM Disinstallo applicazioni inutili (sicuro)
winget uninstall -h Microsoft.OneDrive
winget uninstall -h Microsoft.Teams
winget uninstall -h Microsoft.TeamsMachineWideInstaller

REM Disattivo servizi (sicuro)
sc config "XblAuthManager" start= disabled
sc config "MapsBroker" start= disabled
sc config "XblGameSave" start= disabled
sc config "RetailDemo" start= disabled
sc config "XboxNetApiSvc" start= disabled
sc config "WSearch" start= disabled
sc config "XboxGipSvc" start= disabled
sc config "PhoneSvc" start= disabled

if %AUTOUPGRADE% EQU 1 (
    REM Creo pianificazione per upgrade automatico
    SCHTASKS /CREATE /SC DAILY /TN "AppUpgrade" /TR "C:\scripts\appupgrade.bat" /ST 18:00
)

if %AUTORESTORE% EQU 1 (
    REM Abilito punti di ripristino automatici
    SCHTASKS /CREATE /SC DAILY /TN "Punto di ripristino" /TR "C:\scripts\autorestore.bat" /ST 14:00
)

if %AUTOBKP% EQU 1 (
    REM Abilito backup automatici con schedulazione
    SCHTASKS /CREATE /SC DAILY /TN "Backup Documenti" /TR "C:\scripts\resticBkp.bat" /ST 13:00
    notepad C:\scripts\resticBkp.bat
)

if %TERMSRV%=1 (
    REM Abilito le connessioni desktop remoto multiple
    powershell Set-ExecutionPolicy Bypass -Scope Process -Force; %BASEPATH%\scripts\multiplerdp.ps1

    REM Abilito RDPApps

)

REM Modifiche al registro (sicure)
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v EnableAutoTray /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v NoUseStoreOpenWith /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f
REG ADD "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
REG DELETE "HKLM\System\CurrentControlSet\Services\iphlpsvc" /v DelayedAutoStart /f
REG ADD "HKLM\System\CurrentControlSet\Services\iphlpsvc" /v Start /t REG_DWORD /d 4 /f
REG DELETE "HKLM\System\CurrentControlSet\Services\DPS" /v DelayedAutoStart /f
REG ADD "HKLM\System\CurrentControlSet\Services\DPS" /v Start /t REG_DWORD /d 4 /f
REG DELETE "HKLM\System\CurrentControlSet\Services\WSearch" /v DelayedAutoStart /f
REG ADD "HKLM\System\CurrentControlSet\Services\WSearch" /v Start /t REG_DWORD /d 4 /f
REG DELETE "HKLM\System\CurrentControlSet\Services\WerSvc" /v DelayedAutoStart /f
REG ADD "HKLM\System\CurrentControlSet\Services\WerSvc" /v Start /t REG_DWORD /d 4 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge" /v PreventFirstRunPage /t REG_DWORD /d 0 /f
REG ADD "HKU\S-1-5-21-1616171246-3334492638-2239141655-1110\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f
REG ADD "HKU\S-1-5-21-1616171246-3334492638-2239141655-1110\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f

REM Cambio nome al PC
wmic computersystem where name="%COMPUTERNAME%" call rename name="%PCNAME%"


REM # - Impostazioni MANUAL - #

if %INST% EQU "manual" (
    notepad %BASEPATH%\scripts\manual_app.bat
    notepad %BASEPATH%\scripts\manual_tweaks.bat
    pause
	call %BASEPATH%\scripts\manual_app.bat
	call %BASEPATH%\scripts\manual_tweaks.bat
)

REM # - Impostazioni HOME - #

if %INST% EQU "home" (
    REM Applicazioni per HOME
    winget install -e -h Google.Chrome
    winget install -e -h Adobe.Acrobat.Reader.64-bit    
    winget install -e -h ONLYOFFICE.DesktopEditors
    winget install -e -h WhatsApp.WhatsApp
    winget install -e -h Telegram.TelegramDesktop
    winget install -e -h Dropbox.Dropbox

    REM Assistenza rapida
    winget install -e -h 9P7BP5VNWKX5 --source msstore --accept-source-agreements --accept-package-agreements
    REM JWLibrary
    winget install -e -h 9WZDNCRFJ3B4 --source msstore

    REM Associazioni files
    .pdf=Acrobat.Document.DC

    REM Link di Aiuto sul desktop
    mklink %PUBLIC%\Desktop\AIUTO "C:\script\quickassist.bat"

    SCHTASKS /DELETE /TN "Adobe Acrobat Update Task" /F

    REM Importo POLICY per profilo HOME
    robocopy /mt:128 /S /E /R:0 /W:0 %BASEPATH%\policy\home\ %SYSTEMROOT%\System32\GroupPolicy\
    gpupdate /force

    REM Installo ZOOM
    %BASEPATH%\apps\zoom.exe
	
	REM Importo Start Layout
	powershell Set-ExecutionPolicy Bypass -Scope Process -Force; %BASEPATH%\scripts\StartLayout.ps1
)

REM # - Impostazioni OFFICE - #

if %INST% EQU "office" (
    REM Applicazioni per OFFICE
    winget install -e -h Google.Chrome
    winget install -e -h Adobe.Acrobat.Reader.64-bit
    winget install -e -h PDFsam.PDFsam    
    winget install -e -h ONLYOFFICE.DesktopEditors
    winget install -e -h Mozilla.Firefox
    SCHTASKS /DELETE /TN "Adobe Acrobat Update Task" /F

    REM Associazioni files
    .pdf=Acrobat.Document.DC

    REM Attivo utente Administrator
    net user Administrator %ADMPSW% /active:yes

    REM Importo POLICY per profilo OFFICE
    robocopy /mt:128 /S /E /R:0 /W:0 %BASEPATH%\policy\office\ %SYSTEMROOT%\System32\GroupPolicy\
    gpupdate /force
	
	REM Impostazioni di performance grafiche
	REG ADD "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
	REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
	REG ADD "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d "90 32 07 80 10 00 00 00" /f
	REG ADD "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f
	REG ADD "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f
	REG ADD "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f
	REG ADD "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
	REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
	REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
	REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f
	
	REM Installo MeshAgent
	%BASEPATH%\apps\meshagent.exe -fullinstall
	
	REM Importo Start Layout
	powershell Set-ExecutionPolicy Bypass -Scope Process -Force; %BASEPATH%\scripts\StartLayout.ps1
)

REM # - Impostazioni EXTREME - #

if %INST% EQU "extreme" (
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
    sc config "LanmanServer" start= disabled
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

    REM Disabilito Consumer Experience
    REG ADD HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f

	REM Ulteriori modifiche al registro
	REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f
	REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f
	REG ADD "HKCU\Control Panel\Desktop\JPEGImportQuality" /v  /t REG_DWORD /d 150 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d off /f
	REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f
	REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
	REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
	REG ADD "" /v  /t REG_DWORD /d 0 /f
	REG ADD "" /v  /t REG_DWORD /d 0 /f
	REG ADD "" /v  /t REG_DWORD /d 0 /f
	REG ADD "" /v  /t REG_DWORD /d 0 /f
	REG ADD "" /v  /t REG_DWORD /d 0 /f

    REM Rimuovo AppXProvisionedPackage per tutti gli utenti
    powershell Set-ExecutionPolicy Bypass -Scope Process -Force; %BASEPATH%\appxRemove.ps1

    REM Rimuovo Wallpaper
    REG ADD "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f
    RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
	
	REM Importo Start Layout
	powershell Set-ExecutionPolicy Bypass -Scope Process -Force; %BASEPATH%\scripts\StartLayout.ps1
)

REM Apro WPD e Dism per configurazioni aggiuntive
start C:\bin\WPD.exe