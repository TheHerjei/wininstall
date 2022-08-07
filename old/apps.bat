setlocal
cls
fipath=%~dp0

REM Decommentare le linee per selezionare i programmi

REM ##########################################################################
REM Basic Utility
REM ##########################################################################
choco install 7zip vlc audacity audacity-lame audacity-ffmpeg -y
choco install notepadplusplus -y
choco install wiztree -y
choco install aria2 virtualclonedrive open-shell -Y
choco install naps2 irfanview irfanviewplugins -y
choco install picotorrent cdburnerxp -y
choco install mupdf -y

REM ##########################################################################
REM SysAdmin utility
REM ##########################################################################
REM choco install angryip -y
REM choco install nmap -y
choco install wiztree litemanager-server veeam-agent -y
choco install filezilla -y
choco install litemanager-viewer -y
REM powershell Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
choco install mremoteng -y
REM choco install produkey.portable -y

REM ##########################################################################
REM Development utility
REM ##########################################################################
REM choco install autoit -y
REM choco install git -y
REM choco install python -y
REM choco install ruby -y
REM choco install openjdk -Y
REM choco install javaruntime -y

REM ##########################################################################
REM Communications and Internet
REM ##########################################################################
choco install zoom -y
REM choco install skype -y
choco install thunderbird -y
choco install chromium -y
REM choco install firefox -y
REM choco install googlechrome -y
REM choco install tor -y

REM ##########################################################################
REM Office
REM ##########################################################################
choco install pdfsam pdfxchangeeditor -y
REM choco install pdf24 -y
choco install libreoffice -y
choco install officeproplus2013 -y
REM choco install notable -y
REM choco install scribus -y
REM choco install gimp -y
REM choco install dwgtrueview -y
REM choco install inkscape -y
REM choco install paint.net -y
REM choco install olive -y
REM choco install rawtherapee -y

REM ##########################################################################
REM Security
REM ##########################################################################
REM choco install malwarebytes -y
REM choco install adwcleaner -y
REM choco install squid -y
choco install veeam-agent -y
choco install simple-software-restriction-policy -y

copy %fipath%softwarepolicy.ini C:\Windows\SoftwarePolicy\softwarepolicy.ini
	
echo # Aggiungo Assistenza Remota su Desktop...
mklink %PUBLIC%\Desktop\AIUTO C:\Windows\System32\quickassist.exe

echo # Cambio assiociazioni predefinite...
IF EXIST %fipath%WinFileAssoc.xml (Dism.exe /online /import-defaultappassociations:%fipath%WinFileAssoc.xml) ELSE (echo # Non è presente il file di associazione...)