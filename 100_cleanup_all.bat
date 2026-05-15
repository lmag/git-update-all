@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set DOSSIER_SOURCE=git-update-all
set SCRIPTS="30_git-update-all.bat" "20_install_modules.bat" "10_deploy_all.bat" "100_cleanup_all.bat" "git-update-all.bat" "install_modules.bat" "deploy_all.bat" "cleanup_all.bat"
set CE_SCRIPT=%~nx0

echo Analyse des éléments à nettoyer...

set actions_count=0

if exist "%DOSSIER_SOURCE%\" (
    set /A actions_count+=1
    set action[!actions_count!]=rmdir /S /Q "%DOSSIER_SOURCE%"
)

for %%S in (%SCRIPTS%) do (
    if /I not "%%~S"=="%CE_SCRIPT%" (
        if exist "%%~S" (
            set /A actions_count+=1
            set action[!actions_count!]=del /Q "%%~S"
        )
    )
)

if !actions_count!==0 (
    echo.
    echo ✅ Tout est déjà propre. Aucune action n'est nécessaire.
    echo Il ne reste que ce script. Pour le supprimer, utilisez la commande :
    echo     del /Q "%CE_SCRIPT%"
    echo.
    pause
    exit /b 0
)

echo.
echo ⚠️ ATTENTION : Après confirmation, les commandes suivantes seront exécutées :
for /L %%I in (1,1,!actions_count!) do (
    echo   - !action[%%I]!
)

echo.
set confirmation=
set /p confirmation="Êtes-vous absolument sûr de vouloir continuer ? (o/N) "

set do_clean=0
if /I "!confirmation!"=="o" set do_clean=1
if /I "!confirmation!"=="oui" set do_clean=1
if /I "!confirmation!"=="y" set do_clean=1
if /I "!confirmation!"=="yes" set do_clean=1

if !do_clean!==0 (
    echo Opération annulée.
    echo.
    pause
    exit /b 0
)

echo Exécution du nettoyage...
for /L %%I in (1,1,!actions_count!) do (
    !action[%%I]!
    echo   - Commande exécutée : '!action[%%I]!'
)

echo.
echo ✅ Nettoyage principal terminé.
echo Ce script ne peut pas se supprimer lui-même en cours d'exécution.
echo Pour finaliser, ouvrez cmd et exécutez la commande simple ci-dessous :
echo.
echo     del /Q "%CE_SCRIPT%"
echo.
pause
