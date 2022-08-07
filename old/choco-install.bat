powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

IF ERRORLEVEL == 1 (echo # L'installazione non è andata a buon fine...)
IF ERRORLEVEL == 0 (echo # Installazione completata con successo!)