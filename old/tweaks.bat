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

echo # Rimuovo Appx-Packages...
powershell Get-AppxPackage -AllUser | powershell Remove-AppxPackage -AllUser

echo # Rinomino Computer...
wmic computersystem where caption=%COMPUTERNAME% rename HDW-%RAND%%RAND%%RAND%

echo # Imposto bloc num all'avvio del pc...
reg add "HKU\.DEFAULT\Control Panel\Keyboard" /t REG_DWORD /v InitialKeyboardIndicators /d 2 /f