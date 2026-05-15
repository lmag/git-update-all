@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set LOG_FILE=..\git_update.log
set SELF_NAME=%~nx0

echo Lancement du déploiement de tous les scripts .bat...
echo (Le script '%SELF_NAME%' sera ignoré)

echo.
echo Liste des fichiers qui seront copiés :
for %%F in (*.bat *.csv) do (
    if /I not "%%F"=="%SELF_NAME%" (
        echo   - %%F
    )
)

echo.
set response=
set /p response="Voulez-vous déployer (copier) ces scripts dans le dossier parent ? (o/N) "

set do_deploy=0
if /I "!response!"=="o" set do_deploy=1
if /I "!response!"=="oui" set do_deploy=1
if /I "!response!"=="y" set do_deploy=1
if /I "!response!"=="yes" set do_deploy=1

if !do_deploy!==0 (
    echo Opération annulée par l'utilisateur.
    echo.
    pause
    exit /b 0
)

set DATE_STR=!date! !time:~0,8!
echo --- Session de déploiement démarrée le %DATE_STR% --- >> "%LOG_FILE%"

set FILES_PROCESSED=0

for %%F in (*.bat *.csv) do (
    if /I not "%%F"=="%SELF_NAME%" (
        echo Traitement de : %%F
        copy /Y "%%F" "..\%%F" >nul
        set DATE_STR=!date! !time:~0,8!
        echo [!DATE_STR!] - DÉPLOYÉ : Le script '%%F' a été copié vers le dossier parent. >> "%LOG_FILE%"
        set /A FILES_PROCESSED+=1
    )
)

if %FILES_PROCESSED%==0 (
    echo Aucun fichier .bat trouvé à traiter ^(autre que le script lui-même^).
    set DATE_STR=!date! !time:~0,8!
    echo [!DATE_STR!] - INFO : Aucun fichier .bat pertinent trouvé pour le déploiement. >> "%LOG_FILE%"
) else (
    echo.
    echo ✅ Opération terminée. %FILES_PROCESSED% script^(s^) ont été traités.
)

echo --- Session terminée. --- >> "%LOG_FILE%"
echo Journal des opérations disponible dans le fichier : %LOG_FILE%

echo.
pause
