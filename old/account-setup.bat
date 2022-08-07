setlocal
cls
echo # Controllo volumi...
echo.
echo =================================================
echo list disk | diskpart | findstr /b /c:" "
echo =================================================
echo.
echo # Inserire il numero del lettore DVD
echo # se non presente inserire "N"
set /P dvdPth=# 

if %dvdPth% NEQ N (

> diskpart.tmp (
echo select volume %dvdPht%
echo ASSIGN LETTER="R"
)

diskpart /s diskpart.tmp
del diskpart.tmp
)

echo.
echo =================================================
echo list volume | diskpart | findstr /b /c:" "
echo =================================================
echo.
echo # Inserire il numero del volume per "D:"
echo # Inserisci N per saltare
set /P volumePht=# 

IF %volumePht% NEQ N (
> diskpart.tmp (
echo select volume %volumePht%
echo FORMAT QUICK FS=NTFS LABEL="Dati"
echo ASSIGN LETTER="D"
)

diskpart /s diskpart.tmp
del diskpart.tmp
)


echo # Impostazione Cartelle utente nel disco D:\...

MKDIR D:\Users
MKDIR D:\autoRun.Inf
attrib +r +h +s D:\autoRun.Inf
icacls D:\autoRun.Inf /deny everyone:F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /t REG_EXPAND_SZ /v "ProfilesDirectory" /d "D:\Users" /F

echo.
echo # Creazione nuovi utenti...
echo.

REM qui puoi personalizzare i nomi utente
set aUser=admin
set sUser=utente

net user %aUser% /ADD
net localgroup Administrators %aUser% /ADD

net user %sUser% /ADD