@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set LOG_FILE=git_update.log
set LOG_FILE_PATH=%CD%\%LOG_FILE%

echo =================================================
echo   État actuel des branches des dépôts Git
echo =================================================
echo.

for /D %%D in (*) do (
    if exist "%%D\.git\" (
        pushd "%%D"
        for /F "delims=" %%B in ('git branch --show-current') do set branch=%%B
        popd
        
        rem Ajout d'espaces pour simuler un formatage aligné
        set "dirName=%%D                              "
        set "dirName=!dirName:~0,30!"
        echo !dirName! -^> !branch!
    )
)

echo.
echo =================================================
echo.

set response=
set /p response="Voulez-vous mettre à jour tous ces dépôts (git pull) ? [y/N] "

set do_update=0
if /I "!response!"=="y" set do_update=1
if /I "!response!"=="yes" set do_update=1
if /I "!response!"=="o" set do_update=1
if /I "!response!"=="oui" set do_update=1

if !do_update!==1 (
    echo Lancement de la mise à jour...
    
    echo ================================================= >> "%LOG_FILE_PATH%"
    set DATE_STR=!date! !time:~0,8!
    echo Début de la mise à jour le !DATE_STR! >> "%LOG_FILE_PATH%"
    echo ================================================= >> "%LOG_FILE_PATH%"

    for /D %%D in (*) do (
        if exist "%%D\.git\" (
            echo Mise à jour de : %%D
            echo. >> "%LOG_FILE_PATH%"
            echo --- Mise à jour de [%%D] --- >> "%LOG_FILE_PATH%"
            
            pushd "%%D"
            git pull >> "%LOG_FILE_PATH%" 2>&1
            popd
        )
    )

    echo ================================================= >> "%LOG_FILE_PATH%"
    set DATE_STR=!date! !time:~0,8!
    echo Fin de la mise à jour le !DATE_STR! >> "%LOG_FILE_PATH%"
    echo ================================================= >> "%LOG_FILE_PATH%"
    
    echo.
    echo ✅ Mise à jour terminée. Consultez le fichier '%LOG_FILE%' pour les détails.
) else (
    echo Opération annulée par l'utilisateur.
    
    echo. >> "%LOG_FILE_PATH%"
    echo ================================================= >> "%LOG_FILE_PATH%"
    set DATE_STR=!date! !time:~0,8!
    echo Opération annulée par l'utilisateur le !DATE_STR! >> "%LOG_FILE_PATH%"
    echo ================================================= >> "%LOG_FILE_PATH%"
)

echo.
pause
