    REM # - Browsers - #
    winget install -e -h Google.Chrome
    REM winget install -e -h Mozilla.Firefox
    REM winget install -e -h BraveSoftware.BraveBrowser
    REM winget install -e -h VivaldiTechnologies.Vivaldi
    REM winget install -e -h eloston.ungoogled-chromium

    REM # - PDF Lettori e Tools - #
    winget install -e -h Adobe.Acrobat.Reader.64-bit
    winget install -e -h TrackerSoftware.PDF-XChangeEditor
    winget install -e -h CodeIndustry.MasterPdfEditor
    winget install -e -h PDFsam.PDFsam
    winget install -e -h geeksoftwareGmbH.PDF24Creator

    REM # - Word\Excel e alternative - #
    call C:\sw\OfficeDeploymentTool\InstallOffice.bat
    winget install -e -h ONLYOFFICE.DesktopEditors
    REM winget install -e --id TheDocumentFoundation.LibreOffice
    REM winget install -e --id Apache.OpenOffice
    
    REM # - Messaggistica - #
    winget install -e -h WhatsApp.WhatsApp
    winget install -e -h Telegram.TelegramDesktop

    REM # - Meetings - #
    C:\sw\zoom.exe
    winget install -e -h Zoom.Zoom
    
    REM # - Cloud storage - #
    winget install -e -h Dropbox.Dropbox
    winget install -e -h Google.Drive
    winget install -e -h Microsoft.OneDrive

    REM Assistenza rapida
    winget install -e -h 9P7BP5VNWKX5 --source msstore --accept-source-agreements --accept-package-agreements
    REM JWLibrary
    winget install -e -h 9WZDNCRFJ3B4 --source msstore


    REM # - Ecosistema Apple - #
    REM Itunes
    winget install -e -h 9PB2MZ1ZMB1S --source msstore
    REM Icloud
    winget install -e -h 9PKTQ5699M62 --source msstore